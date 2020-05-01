{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig
, json_c
, python3

, readline
# , pcre
# , linux-pam
# , libbpf
, c-ares
, perl
, libcap
# , linuxHeaders
, pcapc
, libnl
, libyang
, yacc
, flex
}:

stdenv.mkDerivation rec {
  pname = "frr";
  version = "7.3";

  src = fetchFromGitHub {
    owner = "FRRouting";
    repo = "frr";
    rev = "frr-7.3";
    sha256 = "1d7yia02z0h9pifl1gl1q714x4z7mhnfmdhyp8wc4d6rr1iwj8xf";
  };

  buildInputs = [ 
    autoreconfHook
    json_c
    python3
    readline
    # pcre
    # linux-pam
    # libbpf
    c-ares
    libcap
    pcapc
    libnl
    perl
    yacc
    flex
   ];
  #  ++ stdenv.lib.optionals stdenv.isLinux [ linuxHeaders ];

  nativeBuildInputs = [ pkgconfig libyang ];

  # preConfigure = "LD=$CC";

  configureFlags = [
    # "--prefix=/usr"
    # "--enable-exampledir=/usr/share/doc/frr/examples"
    "--localstatedir=/var/run/frr"
    "--sbindir=/usr/lib/frr"
    "--sysconfdir=/etc/frr"
    "--disable-doc"
    # "--enable-systemd"
    "--enable-multipath=64"
    # "--enable-config-rollbacks"
    # "--with-libpam"
    # "--enable-pcreposix"
    "--enable-user=frr"
    "--enable-group=frr"
    "--enable-vty-group=frrvty"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "FRRouting";
    longDescription = ''
      FRR is free software that implements and manages various IPv4 and 
      IPv6 routing protocols. It runs on nearly all distributions of 
      Linux and BSD as well as Solaris and supports all modern CPU 
      architectures.      
    '';
    homepage = "https://frrouting.org/";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ brotherdust ];
  };
}
