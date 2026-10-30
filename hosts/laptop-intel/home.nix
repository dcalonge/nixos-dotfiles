{
  # VA-API rather than Vulkan video on this older GPU
  programs.mpv.config.hwdec = "vaapi";
}
