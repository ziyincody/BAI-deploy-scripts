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
    export ETHERSCAN_API_KEY=8F2EN3ZZYKZKG1MV1J3APZVF24EE9W6129
    unset SSL_CERT_FILE
    export SETH_CHAIN=rinkeby
  
    #export ETH_FROM=0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266
    #export ETH_RPC_URL=http://127.0.0.1:8545/
    #export ETH_RPC_ACCOUNTS=yes
    export ETH_FROM=0x472535d691C9cA0856E4A643252DedE2C0B8a3e2

    setup-env() {
      . ${dds}/lib/setup-env.sh
    }
    export -f setup-env
    setup-env || echo Re-run setup script with \'setup-env\'
  '';
}
