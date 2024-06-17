import json
import os
import sys
from tempfile import mkdtemp

from click.testing import CliRunner
from repository_service_tuf import Dynaconf, cli


def _run(input):
    folder_name = mkdtemp()
    setting_file = os.path.join(folder_name, ".rstuf.yml")
    context = {"settings": Dynaconf(), "config": setting_file}
    runner = CliRunner()
    output = runner.invoke(
        cli.admin.ceremony.ceremony,
        ["--out"],
        input="\n".join(input),
        obj=context,
        catch_exceptions=False,
    )

    return output


def main():
    input_dict = json.loads(sys.argv[1])
    input = [i for i in input_dict.values()]

    print("Using parameters:")
    print(json.dumps(input_dict, indent=2))
    output = _run(input)

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
