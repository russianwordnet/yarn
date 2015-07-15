#!/bin/sh
cat <<EOF
# Facebook
facebook_key: '$FACEBOOK_KEY'
facebook_secret: '$FACEBOOK_SECRET'

# GitHub
github_key: '$GITHUB_KEY'
github_secret: '$GITHUB_SECRET'

# VK
vk_key: '$VK_KEY'
vk_secret: '$VK_SECRET'

# Redis
redis_uri: '$REDIS_URL'
EOF
