{ osConfig, ... }:
let
  token = osConfig.sops.secrets.gh-token.path;
in
{
  # Claude Desktop's FHS sandbox breaks SSH to GitHub, so GitHub goes over HTTPS with a sops token.
  programs = {
    git.settings = {
      url."https://github.com/".insteadOf = "git@github.com:";
      # Reads the file rather than $GH_TOKEN, so systemd services such as clone-repos can push too.
      credential."https://github.com".helper =
        "!f() { test \"$1\" = get && printf 'username=x-access-token\\npassword=%s\\n' \"$(cat ${token})\"; }; f";
    };

    # .zshenv, so non-interactive shells such as an agent's get it too.
    zsh.envExtra = ''
      [[ -r ${token} ]] && export GH_TOKEN="$(<${token})"
    '';
  };
}
