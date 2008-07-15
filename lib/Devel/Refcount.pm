package Devel::Refcount;

use strict;

use base qw( Exporter );
use base qw( DynaLoader );

our @EXPORT_OK = qw( refcount );

our $VERSION = "0.01";

__PACKAGE__->bootstrap( $VERSION );

=head1 NAME

C<Devel::Refcount> - obtain the REFCNT value of a referent

=head1 SYNOPSIS

 use Devel::Refcount qw( refcount );

 my $anon = [];

 print "Anon ARRAY $anon has " . refcount($anon) . " reference\n";

 my $otherref = $anon;

 print "Anon ARRAY $anon now has " . refcount($anon) . " references\n";

=head1 DESCRIPTION

This module provides a single function which obtains the reference count of
the object being pointed to by the passed reference value.

This differs from C<Devel::Peek::SvREFCNT> in that SvREFCNT() gives the
reference count of the SV object itself that it is passed, whereas refcount()
gives the count of the object being pointed to. This allows it to give the
count of any referent (i.e. ARRAY, HASH, CODE, GLOB and Regex types) as well.

=cut

=head1 FUNCTIONS

=cut

=head2 $count = Refcount($ref)

Returns the reference count of the object being pointed to by $ref.

=cut

# Keep perl happy; keep Britain tidy
1;

__END__

=head1 AUTHOR


Paul Evans E<lt>leonerd@leonerd.org.ukE<gt>
