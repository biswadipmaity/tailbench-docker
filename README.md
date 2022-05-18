# Docker for running Tailbench applications

# Build docker image 
Clone in home folder

```
bash setup.sh
cd scripts
bash build.sh
```

# Initialize tailbench server
1. Find and replace all occurances of `TB_DIR` (e.g., `scripts/start.sh`)
2. Fix JDK_PATH
3. `bash start.sh`

# Build applications
```
cd scripts
bash connect.sh
cd src
bash build.sh
```

# Run Experiments

