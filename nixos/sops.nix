{
  sops = {
    defaultSopsFile = ../secrets/hosts.yaml;
    age.keyFile = "/sops/age/keys.txt";
  };
}
