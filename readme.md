### Workspace BUR Scripts

- This is a set of scripts to help backup and restore configurations on a workspace environment for MacOS and Linux, WSL is also supported.
- **Notice: Not suitable for a personal computer usage.** By default the main scripts focus on the backup and restore of cli environments. However you could add your own custom scripts to do whatever operations you want.


##### Usage

- The order to execute the scripts was indicated as the prefix. 
- `00-env-backup.sh`: Backup is the first step in most cases. 
- `01-cli-restore.sh`: Options step to install the basic environment dependencies like `HomeBrew` on MacOS before the restore process.
- `02-env-restore.sh`: Restore the backup from the `archive` directory.

##### File Structure

- The backup files will be saved in the `archive` directory. While doing a restore from previous archive, put archived files at the same leve as the script directory. The name for the archive should be named `archive` exactly, while the directory name for the scripts are not relavent. 

    ```
    .
    ├── archive
    │   ├── cli
    │   ├── custom-scripts
    │   ├── fonts
    │   ├── images
    │   └── settings
    └── scripts
        ├── 00-env-backup.sh
        ├── 01-cli-restore.sh
        ├── 02-env-restore.sh
        ├── common.sh
        ├── custom-scripts
        │   ├── post-backup
        │   ├── post-restore
        │   ├── pre-backup
        │   └── pre-restore
        │   └── manual
        └── readme.md
    ```

#### Custom Scripts

- The directory `custom-scripts` have 4 phases with coresponding sub-directories. Scripts put under the phase directories will be triggered automatically. Meanwhile the sctipts in `custom-scripts/manual` should be triggered manually.
- The environment variables and functions could be re-used in custom scripts.
- Custom scripts will be backuped to the archive in a backup process so that they will be extracted and triggered automatically during a restore process, as long as the archive contains the custom-scripts.