requires "Hash::Merge::Simple" => "0.051";
requires "IO::Socket::SSL" => "1.962";
requires "Mojolicious" => "4.66";
requires "Moo" => "1.004002";
requires "perl" => "5.016";

on 'configure' => sub {
  requires "ExtUtils::MakeMaker" => "6.30";
};
