# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2021-2023 Centuran Consulting, https://centuran.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Output::HTML::Preferences::ColumnFilters;

use strict;
use warnings;

use Kernel::Language qw(Translatable);
use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::System::Web::Request',
    'Kernel::Config',
    'Kernel::System::JSON',
    'Kernel::System::User',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    for my $Name (qw(UserID ConfigItem)) {
        die "Got no $Name!" if ( !$Self->{$Name} );
    }

    return $Self;
}

sub Param {
    my ( $Self, %Param ) = @_;

    my @Params;
    my $GetParam = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'FilterAction' );

    push(
        @Params,
        {
            Name => $Self->{ConfigItem}->{PrefKey},
        },
    );
    return @Params;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $FilterAction = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'FilterAction' );

    return 1 if !defined $FilterAction;

    if ( !$Kernel::OM->Get('Kernel::Config')->Get('DemoSystem') ) {
        KEY:
        for my $Key ( sort keys %{ $Param{GetParam} } ) {
            next KEY if !IsArrayRefWithData($Param{GetParam}->{$Key});

            my %SeenColumns;
            my @Columns;

            for my $Column ( @{ $Param{GetParam}->{$Key} } ) {
                push @Columns, $Column if !$SeenColumns{$Column};
                $SeenColumns{$Column} = 1;
            }

            $Kernel::OM->Get('Kernel::System::User')->SetPreferences(
                UserID => $Param{UserData}->{UserID},
                Key    => $Key . '-' . $FilterAction,
                Value  => $Kernel::OM->Get('Kernel::System::JSON')->Encode(
                    Data => \@Columns
                ),
            );
        }
    }

    $Self->{Message} = Translatable('Preferences updated successfully!');
    return 1;
}

sub Error {
    my ( $Self, %Param ) = @_;

    return $Self->{Error} || '';
}

sub Message {
    my ( $Self, %Param ) = @_;

    return $Self->{Message} || '';
}

1;
