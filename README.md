# SRU Navigation Workspace

This parent repository is wired for SRU navigation training with:

- `sru-navigation-sim`: Isaac Lab task extension
- `sru-navigation-learning`: SRU-enhanced RL framework
- `sru-pytorch-spatial-learning`: standalone SRU memory experiments

## Expected Local Setup

By default, the helper scripts assume:

- Isaac Lab root: `/home/zdp/CodeField/IsaacLab-2.3.2`
- Conda env: `env_isaacsim`

You can override those with environment variables when needed:

```bash
ISAACLAB_DIR=/path/to/IsaacLab ENV_NAME=env_isaacsim ./scripts/setup_nav_training.sh
```

## Direct Training From This Workspace

The helper scripts prepend this workspace to `PYTHONPATH`, so you can train from here without first modifying the Conda environment.

Quick checks:

```bash
./scripts/check_nav_env.sh
./scripts/train_nav.sh
```

## Optional Persistent Setup

```bash
./scripts/setup_nav_training.sh
```

The setup script is only needed if you want `env_isaacsim` itself to permanently use these packages. It will:

- uninstall the preinstalled `rsl-rl-lib` package from `env_isaacsim`
- remove any stale bundled `rsl_rl` package under Isaac Sim if present
- install editable `sru-navigation-learning`
- install editable `sru-navigation-sim`

## Training Defaults

`./scripts/train_nav.sh` defaults to:

- task: `Isaac-Nav-PPO-B2W-Dev-v0`
- env count: `32`
- headless mode: enabled

Common overrides:

```bash
TASK=Isaac-Nav-MDPO-B2W-v0 NUM_ENVS=2048 ./scripts/train_nav.sh
RUN_NAME=debug_b2w MAX_ITERATIONS=300 ./scripts/train_nav.sh
./scripts/train_nav.sh Isaac-Nav-PPO-AoW-D-Dev-v0 --seed 42
```

If you need to move goal/spawn position-table precomputation off GPU on a smaller machine, set it in the task config:

```bash
self.commands.robot_goal.position_table_device = "cpu"
```
