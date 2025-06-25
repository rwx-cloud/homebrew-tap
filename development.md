# Development

### Updating the version of RWX

```sh
bin/update-rwx-formulae X.X.X
```

This script will:
- Fetch the old binaries
- SHA256 them
- Ensure they produce the expected version
- Fetch the new binaries
- SHA256 them
- Ensure they produce the expected version
- Replace the old version references with the new version
- Replace the old SHA256 references with the new ones
