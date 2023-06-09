# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2021-2023 Centuran Consulting, https://centuran.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::CustomerCompany::Event::DynamicFieldObjectNameUpdate;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::System::DynamicField',
);

sub new {
    my ( $Type, %Param ) = @_;

    # Allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    for my $Needed (qw( Data Event Config UserID )) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    for my $Needed (qw( CustomerID OldCustomerID )) {
        if ( !$Param{Data}->{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed in Data!"
            );
            return;
        }
    }

    # Only update if CustomerID has really changed.
    return 1 if lc $Param{Data}->{CustomerID} eq lc $Param{Data}->{OldCustomerID};

    # If the customer ID has been changed, update dynamic field object name for given name and type.
    my $Success = $Kernel::OM->Get('Kernel::System::DynamicField')->ObjectMappingNameChange(
        OldObjectName => $Param{Data}->{OldCustomerID},
        NewObjectName => $Param{Data}->{CustomerID},
        ObjectType    => 'CustomerCompany',
    );

    if ( !$Success ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message =>
                "Unable to change dynamic field object mapping name from $Param{Data}->{OldCustomerID} to $Param{Data}->{CustomerID} for type CustomerCompany!",
        );
        return;
    }

    return 1;
}

1;
