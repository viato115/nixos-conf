{ stdenv, lib, fetchFromGitHub, cmake, ninja, dbus, meson, pkg-config }:

stdenv.mkDerivation rec {
  pname = "iio-hyprland";
  version = "master";

  meta = with lib; {
    description = "Listen to iio-sensor-proxy and auto change Hyprland output orientation; a fork of okeri/iio-sway";
    homepage = "https://github.com/JeanSchoeller/iio-hyprland";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.viato115 ];
  };

  src = fetchFromGitHub {
    owner = "JeanSchoeller";
    repo = "iio-hyprland";
    rev = "a6052f2c3f8416e3dfae2b5bc40bdd2fd12d9f95";
    sha256 = "0dig234m9b80dz9ya88w7vlzhj5lxqgz0gn2chdqjzq0519ww574";
  };

  nativeBuildInputs = [
    cmake
    meson
    ninja
    dbus
    pkg-config
  ];

  configurePhase = ''
    mkdir build
  '';

  buildPhase = ''
    meson build
    cd build
  '';

  installPhase = ''
    ninja install
  '';
}
