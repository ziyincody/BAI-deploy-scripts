let srcs = import ./nix/srcs.nix; in

{ pkgs ? import srcs.makerpkgs { inherit dapptoolsOverrides; }
, dapptoolsOverrides ? {}
, doCheck ? false
, githubAuthToken ? null
}@args: with pkgs;

let
  dds = import ./. args;
in mkShell {
  buildInputs = dds.bins ++ [
    dds
    dapp2nix
    procps
  ];

  shellHook = ''
    export NIX_SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt
    unset SSL_CERT_FILE

  export SETH_CHAIN=ethlive
  # export ETH_FROM=f5808c41c895d88ca8103b5147b5f0e2c910d5a3
  # export ETH_RPC_URL=https://eth-kovan.alchemyapi.io/v2/we7JjRdw2d-UvwuGVOSdkbQ28u8_On-0
  # export ETH_KEYSTORE=./secrets
  export ETH_FROM=0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266
  export ETH_RPC_ACCOUNTS=yes
  export ETH_RPC_URL=http://localhost:8545

    setup-env() {
      . ${dds}/lib/setup-env.sh
    }
    export -f setup-env
    setup-env || echo Re-run setup script with \'setup-env\'
  '';
}
