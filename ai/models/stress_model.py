import os
import torch
import torch.nn as nn
from transformers import PreTrainedModel, PretrainedConfig, AutoConfig
from transformers.modeling_outputs import SequenceClassifierOutput

# ===================== 하드코딩된 설정 ========================
DIM_ECG = 46
DIM_RR = 62
DIM_EDA = 24
DIM_VIDEO = 84
DIM_W2V = 512

TEACHER_FEAT_DIM = 128
NUM_CLASSES = 2
STU_BN_DIM = 256

class TeacherNet(nn.Module):
    def __init__(self):
        super().__init__()
        hidden = TEACHER_FEAT_DIM
        dropout = 0.4
        self.ecg_encoder = nn.Sequential(
            nn.Linear(DIM_ECG, hidden), nn.ReLU(inplace=True), nn.Dropout(p=dropout)
        )
        self.rr_encoder = nn.Sequential(
            nn.Linear(DIM_RR, hidden), nn.ReLU(inplace=True), nn.Dropout(p=dropout)
        )
        self.eda_encoder = nn.Sequential(
            nn.Linear(DIM_EDA, hidden), nn.ReLU(inplace=True), nn.Dropout(p=dropout)
        )
        self.video_encoder = nn.Sequential(
            nn.Linear(DIM_VIDEO, hidden), nn.ReLU(inplace=True), nn.Dropout(p=dropout)
        )
        self.classifier = nn.Sequential(
            nn.Linear(4 * hidden, hidden),
            nn.ReLU(inplace=True),
            nn.Dropout(p=dropout),
            nn.Linear(hidden, NUM_CLASSES)
        )

    def forward(self, x_ecg, x_rr, x_eda, x_video):
        f_ecg = self.ecg_encoder(x_ecg)
        f_rr = self.rr_encoder(x_rr)
        f_eda = self.eda_encoder(x_eda)
        f_video = self.video_encoder(x_video)
        feat = torch.cat([f_ecg, f_rr, f_eda, f_video], dim=1)
        logits = self.classifier(feat)
        return logits, feat

class StudentNet(nn.Module):
    def __init__(self):
        super().__init__()
        dropout = 0.3
        teacher_feat_dim = 4 * TEACHER_FEAT_DIM
        self.encoder = nn.Sequential(
            nn.Linear(DIM_W2V, STU_BN_DIM),
            nn.ReLU(inplace=True),
            nn.Dropout(p=dropout),
            nn.Linear(STU_BN_DIM, teacher_feat_dim),
            nn.ReLU(inplace=True)
        )
        self.norm = nn.LayerNorm(teacher_feat_dim)
        self.classifier = nn.Sequential(
            nn.Dropout(p=dropout),
            nn.Sequential(
                nn.Dropout(p=dropout),
                nn.Linear(teacher_feat_dim, STU_BN_DIM),
                nn.ReLU(inplace=True),
                nn.Dropout(p=dropout),
                nn.Linear(STU_BN_DIM, NUM_CLASSES)
            )
        )

    def forward(self, x_w2v):
        feat = self.encoder(x_w2v)
        feat = self.norm(feat)
        logits = self.classifier(feat)
        return logits, feat

# ==== Transformers Compatibility ==== #

class StressConfig(PretrainedConfig):
    model_type = "audio-classification"
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.hidden_size = STU_BN_DIM
        self.num_labels = NUM_CLASSES

class StudentForAudioClassification(PreTrainedModel):
    config_class = StressConfig

    def __init__(self, config: StressConfig):
        super().__init__(config)
        self.student = StudentNet()
        self.post_init()

    def forward(self, input_values, **kwargs):
        logits, feat = self.student(input_values)
        return SequenceClassifierOutput(logits=logits)

    @classmethod
    def from_pretrained(
        cls,
        pretrained_model_name_or_path,
        *model_args,
        trust_remote_code=False,
        **kwargs
    ):
        config = AutoConfig.from_pretrained(
            pretrained_model_name_or_path,
            trust_remote_code=trust_remote_code,
            **kwargs
        )
        model = cls(config)

        # 🟢 [핵심] 경로가 폴더(로컬)면 직접 파일 찾기
        if os.path.isdir(pretrained_model_name_or_path):
            bin_path = os.path.join(pretrained_model_name_or_path, "pytorch_model.bin")
        else:
            from huggingface_hub import hf_hub_download
            bin_path = hf_hub_download(
                repo_id=pretrained_model_name_or_path,
                filename="pytorch_model.bin",
            )
        sd = torch.load(bin_path, map_location="cpu", weights_only=True)
        prefixed_sd = {f"student.{k}": v for k, v in sd.items()}
        model.load_state_dict(prefixed_sd, strict=True)
        return model
