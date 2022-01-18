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
    hevm
    curl
    which
    git
  ];

  shellHook = ''
    export NIX_SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt
    unset SSL_CERT_FILE
  export PATH="/nix/store/a7i4hha4gh7fsbw7bfz51l2dkhgvb59a-curl-7.65.3-bin/bin/curl:$PATH"
  export SETH_CHAIN=ethlive
  # export ETH_FROM=0xf5808c41c895d88ca8103b5147b5f0e2c910d5a3
  # export ETH_RPC_URL=https://eth-kovan.alchemyapi.io/v2/we7JjRdw2d-UvwuGVOSdkbQ28u8_On-0
  # export ETH_KEYSTORE=./secrets
  # export ETH_PASSWORD=./.pwd
  export ETH_FROM=0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266
  export ETH_RPC_ACCOUNTS=yes
  export ETH_RPC_URL=http://localhost:8546

    setup-env() {
      . ${dds}/lib/setup-env.sh
    }
    export -f setup-env
    setup-env || echo Re-run setup script with \'setup-env\'
  '';
}
