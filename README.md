
obtain NordVPN Wireguard key like so:

curl -s -u token:<YOUR_NORD_TOKEN> \
  https://api.nordvpn.com/v1/users/services/credentials \
| jq -r '.nordlynx_private_key'
