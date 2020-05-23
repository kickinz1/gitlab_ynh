gitlab_version="13.0.0"

# sha256sum found here: https://packages.gitlab.com/gitlab

gitlab_x86_64_debian_version="$(lsb_release -sc)"

if [ "$gitlab_x86_64_debian_version" = "buster" ]
then
	gitlab_x86_64_source_sha256="4322ea81b30118a1616765abf34bf6ed9442675bac91d027babfc31d97938fe9"
else
	gitlab_x86_64_source_sha256="71bf1a95739f78131eb23e016d663e18954758d00a8960ec811067287e5bd797"
fi

gitlab_arm_source_sha256="bb98a9a282c3c712abc4f5f45d761e949a0347afd9288cfd24ce7529182de30e"

gitlab_filename="gitlab-ce-${gitlab_version}.deb"

# Action to do in case of failure of the package_check
package_check_action() {
	local sysctl_file="$final_path/embedded/cookbooks/package/resources/gitlab_sysctl.rb"
	ynh_replace_string --match_string="command \"sysctl -e \(.*\)\"" --replace_string="command \"sysctl -e \1 || true\"" --target_file=$sysctl_file
	
	sysctl_file="/opt/gitlab/embedded/cookbooks/package/recipes/sysctl.rb"
	ynh_replace_string --match_string="command \"sysctl -e \(.*\)\"" --replace_string="command \"sysctl -e \1 || true\"" --target_file=$sysctl_file
}
