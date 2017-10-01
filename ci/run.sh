#!/usr/bin/env bash
set -eo pipefail

# repo,tag,soname
MODULES=(
	'simpl/ngx_devel_kit,v0.3.0,ndk_http'
	'openresty/lua-nginx-module,v0.10.10,ngx_http_lua'
)

usage() {
	cat <<-EOU
		usage: $self [<docker-image>]
		 e.g.: $self praekeltfoundation/nginx-module-builder
	EOU
}

docker_image="$1"; shift || { usage >&2; exit 1; }

download_archive() {
	local repo="$1"; shift
	local tag="$1"; shift

	echo "Downloading '$repo' tag '$tag'..."

	local org="${repo%/*}"
	local name="${repo#*/}"
	local url="https://github.com/${org}/${name}/archive/${tag}.tar.gz"

	mkdir -p "in/$name"
	wget -O - "$url" | tar -xzC "in/$name" --strip-components=1
}

mkdir -p in

docker_volume_opts=()
docker_source_args=()
for module in "${MODULES[@]}"; do
	parts=(${module//,/ })

	download_archive "${parts[0]}" "${parts[1]}"

	name="${parts[0]#*/}"
	docker_volume_opts+=(-v "$(pwd)/in/$name:/usr/src/$name")
	docker_source_args+=("/usr/src/$name")
done

echo 'Building Nginx modules...'
docker run \
	--rm \
	-v "$(pwd)/objs:/usr/src/nginx/objs" \
	${docker_volume_opts[@]} \
	"$docker_image" \
		${docker_source_args[@]}


# Name the module .so files to provide version information
nginx_version="$(docker inspect "$docker_image" | \
	jq -r '.[].ContainerConfig.Env[] | scan("^NGINX_VERSION=(.*)")[]')"

echo "Detected Nginx version '$nginx_version'"

mkdir -p out
for module in "${MODULES[@]}"; do
	parts=(${module//,/ })

	old_name="${parts[2]}_module"
	new_name="${old_name}-${parts[1]}-${nginx_version}"
	cp "objs/${old_name}.so" "out/${new_name}.so"

	echo "Built 'out/$new_name.so'"
done
