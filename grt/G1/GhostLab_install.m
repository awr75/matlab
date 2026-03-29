function GhostLab_install
ghostlab_path = '\\shared.zhaw.ch\shared$\pools\t\T-ALLE-GhostLab';
err_msg = ['Installation not possible. Check if you have access to folder "',ghostlab_path,'".'];

fid = fopen([ghostlab_path,'\GhostLabVersion.txt'], 'r');
if fid>0
    Install_version = fscanf(fid,'%c');
    fclose(fid);
else
    error(err_msg)
end

Install_path = [ghostlab_path,'\Installer_',strrep(Install_version,'.','_'),'\GhostLab_Install_Functions'];
if exist(Install_path,'file')
    addpath(Install_path);
else
    error(err_msg)
end

for k=1:5
    if ~isempty(which('GhostLab_install_app'))
        try
            GhostLab_install_app
        catch
            error(err_msg)
        end
        return
    else
        pause(1)
    end
end
error(err_msg)
