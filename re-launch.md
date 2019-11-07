# Instructions for Re-launch

## Who is this for?

If you participated in the previous attempted launch of `kava-1` as a validator or node operator, this guide is for you. If you have not set up a validator or node on the `kava-1` chain previously, these instructions do not apply.

### Steps

If you are using the same node that you used for the failed launch, you need to reset the state and download the latest genesis file.

**Note** It is critically important that all validators participating in the relaunch have downloaded and verified the correct genesis file. It is also important that the state from the previous launch attempt has been reset.

```sh
# Stop kvd if it is currently running. This depends on how you are running the kvd process. If using 'systemctl', then
sudo systemctl stop kvd

# To be sure that you do not have an instance of kvd running,
# the following command should have blank output
# If you see one or more process IDs from this command,
# you still need to shutdown kvd and should not proceed to the next steps
pgrep kvd

# Remove the previous genesis file
rm -rf $HOME/.kvd/config/genesis.json

# Download the latest genesis file to $HOME/.kvd/config/genesis.json
wget -O ~/.kvd/config/genesis.json https://raw.githubusercontent.com/Kava-Labs/launch/master/kava-1/genesis.json
# Verify the genesis file
sha256sum $HOME/.kvd/config/genesis.json
# The output of sha256sum should be 05942be6e582d0688136d6e64bc99363fde80ecbbbffa683fd894698f007caa3

# Reset your node. Make sure you have shut down kvd!
kvd unsafe-reset-all

```

After you have completed these steps and verified the correctness of the genesis file, you should have your node standing by for launch on Nov 12, 2019 at 14:00 UTC.
