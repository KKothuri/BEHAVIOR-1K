import hydra
from hydra.utils import instantiate
from il_lib.utils.config_utils import register_omegaconf_resolvers
from il_lib.utils.checkpoint_utils import load_policy_wrapper
from omegaconf import OmegaConf
from omnigibson.learning.utils.network_utils import WebsocketPolicyServer

@hydra.main(config_name="base_config", config_path="il_lib/configs", version_base="1.1")
def main(cfg):
    """Main function to start the WebsocketPolicyServer."""
    register_omegaconf_resolvers()
    OmegaConf.resolve(cfg)
    OmegaConf.set_struct(cfg, False)
    policy_wrapper = load_policy_wrapper(cfg)

    server = WebsocketPolicyServer(
        policy=policy_wrapper,
        host="0.0.0.0",
        port=8000,
    )
    server.serve_forever()

if __name__ == "__main__":
    main()
