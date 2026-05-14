{ pkgs  ? import <nixpkgs> {}, ... }:

pkgs.mkShell rec {
  packages = with pkgs; [ hare harec haredoc helix lc3tools hexyl ];
}
