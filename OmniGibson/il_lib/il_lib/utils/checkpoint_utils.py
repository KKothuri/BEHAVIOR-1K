from hydra.utils import instantiate
from il_lib.utils.training_utils import load_state_dict, load_torch

def load_policy_wrapper(cfg):
    """Loads a policy model based on a Hydra config object."""    
    policy = instantiate(cfg.module, _recursive_=False)
    
    ckpt = load_torch(
        cfg.ckpt_path,
        map_location="cpu",
    )
    
    load_state_dict(
        policy,
        ckpt["state_dict"],
        strict=True
    )
    
    policy = policy.to("cuda")
    policy.eval()
    policy_wrapper = instantiate(cfg.policy_wrapper)
    policy_wrapper.policy = policy
    return policy_wrapper