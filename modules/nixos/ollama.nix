{pkgs, ...}: {
  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm;
    loadModels = ["qwen2.5-coder:14b" "gemma4:latest" "gemma4:12b"];
    syncModels = true;
  };

  services.open-webui = {
    enable = true;
  };
}
