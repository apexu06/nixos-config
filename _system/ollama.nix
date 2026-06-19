{pkgs, ...}: {
  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm;
    loadModels = ["qwen3-coder:latest" "qwen2.5-coder:14b" "gemma4:latest"];
    syncModels = true;
  };
}
