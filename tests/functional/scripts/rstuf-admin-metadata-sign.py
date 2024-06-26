import json
import os
import sys
from tempfile import mkdtemp
from unittest import mock

from click.testing import CliRunner
from repository_service_tuf import Dynaconf, cli


def _run(input, selection):
    folder_name = mkdtemp()
    setting_file = os.path.join(folder_name, ".rstuf.yml")
    test_settings = Dynaconf()
    test_settings.SERVER = "http://repository-service-tuf-api"
    context = {"settings": test_settings, "config": setting_file}

    runner = CliRunner()

    # key selection
    cli.admin.helpers._select = mock.MagicMock()
    cli.admin.helpers._select.side_effect = selection

    output = runner.invoke(
        cli.admin.sign.sign,
        ["--out"],
        input="\n".join(input),
        obj=context,
        catch_exceptions=False,
    )

    return output


def main():
    input_dict = json.loads(sys.argv[1])
    selection_dict = json.loads(sys.argv[2])
    input = [i for i in input_dict.values()]
    selection = [i for i in selection_dict.values()]

    print("Using parameters:")
    print(json.dumps(input_dict, indent=2))
    output = _run(input, selection)

    print(f"\nExit code: {output.exit_code}")
    print("\nOutput: ")
    print(output.stdout)
    if output.stderr_bytes is not None:
        print(f"\nError\n: {output.stderr}")

    if output.exception:
        print(f"Exception: {output.exception}")
        print(f"Exception Info: {output.exc_info}")
        output.exc_info

    sys.exit(output.exit_code)


if __name__ == "__main__":
    main()
