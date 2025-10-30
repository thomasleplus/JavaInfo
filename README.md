# JavaInfo

A Perl utility to extract Java version information from compiled Java class files by analyzing their bytecode headers.

## Description

JavaInfo reads Java `.class` files and identifies the Java version used to compile them. It works by examining the bytecode header of each class file, specifically the magic number (`0xCAFEBABE`) and the major/minor version numbers that indicate the Java compiler version.

The tool can process individual files or recursively scan entire directories, making it useful for:

- Auditing Java dependencies and libraries
- Verifying compilation targets in build artifacts
- Identifying version mismatches in projects
- Understanding compatibility requirements

## Requirements

- Perl 5.x or later
- Standard Perl modules (included by default):
  - `File::Spec::Functions`

## Installation

1. Clone or download this repository
2. Make the script executable:
   ```bash
   chmod +x JavaInfo
   ```
3. Optionally, add it to your PATH:
   ```bash
   sudo cp JavaInfo /usr/local/bin/
   ```

## Usage

```bash
./JavaInfo <file or directory> [<file or directory> ...]
```

### Examples

**Analyze a single class file:**

```bash
./JavaInfo MyClass.class
```

**Scan a directory recursively:**

```bash
./JavaInfo /path/to/project/target/classes
```

**Process multiple paths:**

```bash
./JavaInfo src/main/java build/classes lib/*.jar
```

### Example Output

```text
MyClass.class: Java 11 [0/55]
Utils.class: Java 8 [0/52]
LegacyCode.class: Java 1.4.2 [0/48]
```

The output format is:

```text
<filename>: Java <version> [<minor>/<major>]
```

Where:

- `<filename>` is the path to the class file
- `<version>` is the Java version (e.g., 8, 11, 17, or 1.4.2 for older versions)
- `<minor>/<major>` are the bytecode version numbers

## Java Version Mapping

The tool uses the following mapping between bytecode major versions and Java releases:

| Major Version | Minor Version | Java Version |
| ------------- | ------------- | ------------ |
| 45            | 0-3           | 1.0.2        |
| 45            | 4+            | 1.1.8        |
| 46            | -             | 1.2.2        |
| 47            | -             | 1.3.1        |
| 48            | -             | 1.4.2        |
| 49            | -             | 5            |
| 50            | -             | 6            |
| 51            | -             | 7            |
| 52            | -             | 8            |
| ...           | -             | ...          |

For Java 5 and later, the formula is: **Java Version = Major Version - 44**

## Error Handling

The script will display error messages and exit if:

- A file cannot be opened or read
- A directory cannot be accessed
- A file is not a valid Java class file (missing the `0xCAFEBABE` magic number)

## Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

See [LICENSE](LICENSE) file for details.

## Security

For security concerns, please see [SECURITY.md](SECURITY.md).

## Code of Conduct

This project adheres to a code of conduct. See [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) for details.
