{ inputs, ... }:

{
  imports = [
    inputs.xremap-flake.nixosModules.default
  ];
  services.xremap = {
    
  };
  
}
