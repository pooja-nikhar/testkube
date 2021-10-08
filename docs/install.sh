echo "Getting kubectl-testkube plugin"
#!/bin/sh 

if [ ! -z "${DEBUG}" ]; 
then set -x 
fi 

_detect_arch() { 
    case $(uname -m) in 
    amd64|x86_64) echo "x86_64" 
    ;; 
    arm64|aarch64) echo "arm64" 
    ;; 
    i386) echo "i386" 
    ;; 
    *) echo "Unsupported processor architecture"; 
    return 1 
    ;;
     esac 
}

_download_url() { 
        local arch="$(_detect_arch)" 
        if [ -z "$TESTKUBE_VERSION" ]
        then
                local version=`curl -s https://api.github.com/repos/kubeshop/testkube/releases/latest 2>/dev/null | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/'`
                echo "https://github.com/kubeshop/testkube/releases/download/${version}/testkube_${version:1}_$(uname)_$arch.tar.gz"       
        else   
                echo "https://github.com/kubeshop/testkube/releases/download/v${TESTKUBE_VERSION}/testkube_${TESTKUBE_VERSION}_$(uname)_$arch.tar.gz" 
        fi
}

echo "Downloading testkube from URL: $(_download_url)" 
curl -sSLf $(_download_url) > testkube.tar.gz 
tar -xzf testkube.tar.gz kubectl-testkube 
rm testkube.tar.gz
mv kubectl-testkube /usr/local/bin/kubectl-testkube
echo "kubectl-testkube installed in /usr/local/bin/kubectl-testkube"

