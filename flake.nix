{
  description = "A collection of nix flake templates";
  outputs = { self }: {
    templates.article = {
      path = ./article;
      description = "Research paper template";
    };
    defaultTemplate = self.templates.article;
  };
}
