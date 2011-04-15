#  You may distribute under the terms of either the GNU General Public License
#  or the Artistic License (the same terms as Perl itself)
#
#  (C) Paul Evans, 2008-2011 -- leonerd@leonerd.org.uk

package Devel::Refcount;

use strict;
use warnings;

our $VERSION = '0.08_001';

use Exporter 'import';
our @EXPORT_OK = qw( refcount );

require XSLoader;
if( !eval { XSLoader::load( __PACKAGE__, $VERSION ) } ) {
   *refcount = \&_refcount_pp;
   require B;
}

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

=cut

=head1 FUNCTIONS

=cut

=head2 $count = refcount($ref)

Returns the reference count of the object being pointed to by $ref.

=cut

# This normally isn't used if the XS code is loaded
sub _refcount_pp
{
   B::svref_2object( shift )->REFCNT;
}

=head1 COMPARISON WITH SvREFCNT

This function differs from C<Devel::Peek::SvREFCNT> in that SvREFCNT() gives
the reference count of the SV object itself that it is passed, whereas
refcount() gives the count of the object being pointed to. This allows it to
give the count of any referent (i.e. ARRAY, HASH, CODE, GLOB and Regexp types)
as well.

Consider the following example program:

 use Devel::Peek qw( SvREFCNT );
 use Devel::Refcount qw( refcount );
 
 sub printcount
 {
    my $name = shift;
 
    printf "%30s has SvREFCNT=%d, refcount=%d\n",
       $name, SvREFCNT($_[0]), refcount($_[0]);
 }
 
 my $var = [];

 printcount 'Initially, $var', $var;
 
 my $othervar = $var;

 printcount 'Before CODE ref, $var', $var;
 printcount '$othervar', $othervar;
 
 my $code = sub { undef $var };
 
 printcount 'After CODE ref, $var', $var;
 printcount '$othervar', $othervar;

This produces the output

                Initially, $var has SvREFCNT=1, refcount=1
          Before CODE ref, $var has SvREFCNT=1, refcount=2
                      $othervar has SvREFCNT=1, refcount=2
           After CODE ref, $var has SvREFCNT=2, refcount=2
                      $othervar has SvREFCNT=1, refcount=2

Here, we see that SvREFCNT() counts the number of references to the SV object
passed in as the scalar value - the $var or $othervar respectively, whereas
refcount() counts the number of reference values that point to the referent
object - the anonymous ARRAY in this case.

Before the CODE reference is constructed, both $var and $othervar have
SvREFCNT() of 1, as they exist only in the current lexical pad. The anonymous
ARRAY has a refcount() of 2, because both $var and $othervar store a reference
to it.

After the CODE reference is constructed, the $var variable now has an
SvREFCNT() of 2, because it also appears in the lexical pad for the new
anonymous CODE block.

=cut

=head1 PURE-PERL FALLBACK

An XS implementation of this function is provided, and is used by default. If
the XS library cannot be loaded, a fallback implementation in pure perl using
the C<B> module is used instead. This will behave identically, but is much
slower.

        Rate   pp   xs
 pp 225985/s   -- -66%
 xs 669570/s 196%   --

=head1 SEE ALSO

=over 4

=item *

L<Test::Refcount> - assert reference counts on objects

=back

=head1 AUTHOR

Paul Evans <leonerd@leonerd.org.uk>

=cut

0x55AA;
