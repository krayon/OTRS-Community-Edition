# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2021-2023 Centuran Consulting, https://centuran.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::Stats::Generate');

my $ExitCode = $CommandObject->Execute();

# no options
$Self->Is(
    $ExitCode,
    1,
    "No options (should fail)",
);

# invalid stats number format
$ExitCode = $CommandObject->Execute( '--number', 'XX' );
$Self->Is(
    $ExitCode,
    1,
    "Invalid stats number format",
);

1;
