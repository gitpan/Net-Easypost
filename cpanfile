requires "Hash::Merge::Simple" => "0.051";
requires "IO::Socket::SSL" => "1.89";
requires "Mojolicious" => "3.62";
requires "Moo" => "1.000006";
requires "perl" => "5.014";

on 'configure' => sub {
  requires "ExtUtils::MakeMaker" => "6.30";
};
