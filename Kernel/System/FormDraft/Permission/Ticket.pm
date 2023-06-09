# --
# Copyright (C) 2021-2023 Centuran Consulting, https://centuran.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::FormDraft::Permission::Ticket;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
    'Kernel::System::Ticket',
);

=head1 NAME

Kernel::System::FormDraft::Permission::Ticket

=head1 DESCRIPTION

Permission backend for the form draft Ticket ObjectType.

=head1 PUBLIC INTERFACE

=head2 new()

Don't use the constructor directly, use the ObjectManager instead:

    my $FormDraftTicketPermissionObject = $Kernel::OM->Get('Kernel::System::FormDraft::Permission::Ticket');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 ObjectPermission()

checks read permission for a given object and UserID.

    $Permission = $FormDraftTicketPermissionObject->ObjectPermission(
        ObjectType => 'Ticket',
        ObjectID   => 123,
        UserID     => 1,
    );

=cut

sub ObjectPermission {
    my ( $Self, %Param ) = @_;

    for my $Argument (qw(ObjectType ObjectID UserID)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    return $Kernel::OM->Get('Kernel::System::Ticket')->TicketPermission(
        Type     => 'ro',
        TicketID => $Param{ObjectID},
        UserID   => $Param{UserID},
    );
}

1;
