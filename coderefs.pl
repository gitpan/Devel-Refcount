package Cleanup;

sub new
{
   my $class = shift;
   my $code = shift;
   print "New Cleanup at $code\n";
   return bless $code, $class;
}

sub DESTROY
{
   my $self = shift;
   print "DESTROY $self\n";
   $self->();
}

package main;

sub LEAVE(&) { return Cleanup->new( shift ) }

{
   my $c = LEAVE { print "Left the outer block\n" };

   print "Now in the outer block\n";

   {
      my $c = LEAVE { print "Left the inner block\n" };

      print "Now in the inner block\n";
   }

   print "Still in the outer block\n";
}

