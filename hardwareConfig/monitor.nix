{ config, pkgs, ... }:

{
  # 1. Package your custom EDID binary into firmware
  hardware.firmware = [
    (pkgs.runCommand "custom-edid" {} ''
      mkdir -p $out/lib/firmware/edid
      cp ${./resources/75hz.bin} $out/lib/firmware/edid/75hz.bin
    '')
  ];

  # 2. Tell the kernel to override DP-1's EDID with 75hz.bin
  boot.kernelParams = [
    "drm.edid_firmware=HDMI-A-1:resources/75hz.bin"
  ];
}
