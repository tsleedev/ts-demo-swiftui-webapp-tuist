// Bridge 관련 이벤트 핸들러 설정
document.addEventListener("DOMContentLoaded", function() {
    // 페이지 로딩 완료 후 실행될 코드
    // URL에서 쿼리 파라미터를 파싱하는 함수
    function getQueryParam(param) {
        var queryString = window.location.search.substring(1);
        var params = queryString.split("&");
        for (var i = 0; i < params.length; i++) {
            var pair = params[i].split("=");
            if (pair[0] == param) {
                return decodeURIComponent(pair[1]);
            }
        }
        return null;
    }
    
    // 'page' 쿼리 파라미터 값을 가져옴
    var page = getQueryParam("page");
    
    // 제목이 존재하면, 페이지 상단에 제목을 추가
    if (page) {
        var header = document.createElement("h1");
        header.textContent = "Page " + page;
        document.body.insertBefore(header, document.body.firstChild);
    } else {
        var header = document.createElement("h1");
        header.textContent = "Main Page";
        document.body.insertBefore(header, document.body.firstChild);
    }
});

/* Bridge 기능 */
document.getElementById("bridgeFirebaseLogScreen").onclick = function() {
    firebaseLogScreen("스크린_테스트");
};

document.getElementById("bridgeFirebaseLogEvent").onclick = function() {
    var message = {
        value: "파라미터",
    };
    firebaseLogEvent("이벤트_테스트", message);
};

document.getElementById("bridgeFirebaseSetUserProperty").onclick = function() {
    firebaseSetUserProperty("Property_테스트", "PropertyValue");
};

document.getElementById("bridgeGetPermissionLocation").onclick = function() {
    callPlatformSpecificMethod('getPermissionLocation', {}, function(response) {
        onAppResponse("App Response: " + JSON.stringify(response));
    });
};

document.getElementById("bridgeGetLocation").onclick = function() {
    callPlatformSpecificMethod('getLocation', {}, function(response) {
        onAppResponse("App Response: " + JSON.stringify(response));
    });
};

document.getElementById("bridgeStartUpdatingLocation").onclick = function() {
    var message = {
        callbackId: "cb_UpdatingLocation"
    };
    callPlatformSpecificMethod('startUpdatingLocation', message);
};

document.getElementById("bridgeStopUpdatingLocation").onclick = function() {
    callPlatformSpecificMethod('stopUpdatingLocation', {}, function(response) {
        onAppResponse("App Response: stopUpdatingLocation");
    });
};

document.getElementById("bridgeSetDestination").onclick = function() {
    const destination = {
        latitude: 37.4967867,
        longitude: 126.9978993
    };
    callPlatformSpecificMethod('setDestination', destination, function(response) {
        onAppResponse("App Response: setDestination(" + response + ")");
    });
};

document.getElementById("bridgeRemoveDestination").onclick = function() {
    callPlatformSpecificMethod('removeDestination', {}, function(response) {
        onAppResponse("App Response: removeDestination");
    });
};

document.getElementById("bridgeRevealSettings").onclick = function() {
    callPlatformSpecificMethod('revealSettings', {}, function(response) {
        onAppResponse("App Response: revealSettings");
    });
};

document.getElementById("bridgeOpenPhoneSettings").onclick = function() {
    callPlatformSpecificMethod('openPhoneSettings', {}, function(response) {
        onAppResponse("App Response: openPhoneSettings");
    });
};


/* 기본 브라우저 기능 */
document.getElementById("tapOpenAndCloseWindow").onclick = function() {
    openNextPageInNewWindow()
    setTimeout(function() {
        window.close();
    }, 1000); // 1000밀리초(1초) 후에 창 닫음
};

document.getElementById("tapOpenWindow").onclick = function() {
    openNextPageInNewWindow()
};

document.getElementById("tapOpenWindowPlayStore").onclick = function() {
    window.open('https://play.google.com/store/apps/details?id=com.google.android.googlequicksearchbox', '_blank');
};

document.getElementById("tapOpenWindowAppStore").onclick = function() {
    window.open('https://apps.apple.com/us/app/google/id284815942', '_blank');
};

document.getElementById("tapCloseWindow").onclick = function() {
    window.close();
};

document.getElementById("tapCloseParentWindow").onclick = function() {
    if (window.opener) {
        window.opener.close();
    } else {
        alert("No opener available");
    }
};

document.getElementById("tapOpenPopupWindow").onclick = function() {
    window.open('popupHtml.html', '_blank');
};

document.getElementById("tapGetUserAgent").onclick = function() {
    var userAgent = navigator.userAgent;
    alert(userAgent);
};

document.getElementById("tapShowAlert").onclick = function() {
    alert("Alert 테스트");
};

document.getElementById("tapShowConfirm").onclick = function() {
    if (confirm("이 작업을 계속 진행하시겠습니까?")) {
        setTimeout(function() {
            alert("작업을 계속 진행합니다.");
        }, 500); // 500밀리초(0.5초) 후에 alert 실행
    } else {
        setTimeout(function() {
            alert("작업을 취소합니다.");
        }, 500); // 500밀리초(0.5초) 후에 alert 실행
    }
};

// 부모에게 값 전달
document.getElementById("tapSendMessageToParent").onclick = function() {
    setParentText();
};

document.getElementById('tapCheckPermissionCamera').onclick = function() {
//    alert("작업을 취소합니다.");
    checkCameraPermission((state) => { // 화살표 함수를 사용한 콜백
//        alert('camera permission state is ' + state);
        if (state === 'granted') {
            alert('카메라 접근 권한이 허용되었습니다.');
            // 카메라 접근 권한이 허용된 경우의 로직
        } else if (state === 'prompt') {
            alert('카메라 접근 권한이 prompt.');
        }
    });
//    document.getElementById('cameraInput').click(); // input[type=file] 트리거
};

document.getElementById('tapCheckPermissionLocation').onclick = function() {
    checkLocationPermission((state) => {
        if (state === 'granted') {
            alert('Location access is granted.');
            // 위치 접근 권한이 허용된 경우의 로직
        } else if (state === 'prompt') {
            alert('Location access is prompt.');
            // 위치 접근 권한이 프롬프트 상태인 경우의 로직
        } else if (state === 'denied') {
            alert('Location access is denied.');
            // 위치 접근 권한이 거부된 경우의 로직
        }
    });
};

document.getElementById('cameraInput').addEventListener('change', function(event) {
    const fileInfo = document.getElementById('fileInfo');
    const previewImage = document.getElementById('previewImage');
    const file = event.target.files[0];

    if (file) {
        // 이미지 미리보기
        const reader = new FileReader();
        reader.onload = function(e) {
            previewImage.src = e.target.result;
            previewImage.style.display = 'inline'; // 이미지 미리보기를 인라인으로 표시

            // 파일 이름 표시는 이미지 미리보기 후에 진행
            fileInfo.textContent = `${file.name}`;
            fileInfo.style.display = 'block'; // 파일 정보 표시
        };
        reader.readAsDataURL(file); // 파일 읽기 시작
    } else {
        // 파일 선택 취소시 정보 초기화
        previewImage.style.display = 'none';
        previewImage.src = '';
        fileInfo.textContent = '';
    }
});

/* Function */
function openNextPageInNewWindow() {
    // 현재 URL에서 페이지 번호 추출
    function getQueryParam(param) {
        var queryString = window.location.search.substring(1);
        var params = queryString.split("&");
        for (var i = 0; i < params.length; i++) {
            var pair = params[i].split("=");
            if (pair[0] === param) {
                return decodeURIComponent(pair[1]);
            }
        }
        return null;
    }

    // 'page' 쿼리 파라미터 값 추출 및 다음 페이지 번호 계산
    var currentPage = getQueryParam("page");
    var nextPage = currentPage ? Number(currentPage) + 1 : 1;  // 페이지 정보가 없으면 기본값으로 1로 설정

    // 새 창에서 다음 페이지 URL 열기
    var baseUrl = window.location.href.split('?')[0];
    var newUrl = baseUrl + "?page=" + nextPage;
    window.open(newUrl, '_blank');
}

// bridge
function callPlatformSpecificMethod(methodName, message, callback) {
    if (callback) {
        const callbackId = 'cb_' + new Date().getTime();
        message.callbackId = callbackId;
        // 콜백 함수를 글로벌로 설정
        window[callbackId] = function(response) {
            onAppResponse(callbackId);
            callback(response);
            delete window[callbackId];
        };
    }
    
    resetMessage()
    if (window.AnalyticsWebInterface) {
        // Android 인터페이스 호출
        if (typeof window.AnalyticsWebInterface[methodName] === 'function') {
            window.AnalyticsWebInterface[methodName](JSON.stringify(message));
        }
    } else if (window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers[methodName]) {
        // iOS 인터페이스 호출
        window.webkit.messageHandlers[methodName].postMessage(message);
    } else {
        // 플랫폼 인터페이스를 찾을 수 없음
        if (callback) {
            callback({ error: "No native " + methodName + " method found." });
        } else {
            alert("No native " + methodName + " method found.");
        }
    }
}

// 앱에서 javascript로 응답 확인용
function resetMessage() {
    var messageContainer = document.getElementById('message-container');
    messageContainer.innerText = '응답 대기';
}

function onAppResponse(message) {
    var messageContainer = document.getElementById('message-container');
    messageContainer.innerText = message;
}

// 부모와 자식 간의 통신
window.addEventListener("message", (event) => {
    var messageContainer = document.getElementById('message-container');
    messageContainer.innerText = event.data;
}, false);

function setParentText() {
    if (window.opener) {
        window.opener.postMessage("자식에서 전달", "*"); // 최대한 안전을 위해 '*' 대신 정확한 부모 URL 사용
    } else {
        alert("No opener available");
    }
}

// Firebase
function firebaseLogScreen(name) {
    if (!name) {
        return;
    }
    
    var message = {
        screenName: name,
    };
    
    callPlatformSpecificMethod('firebaseLogScreen', message);
}

function firebaseLogEvent(name, params) {
    if (!name) {
        return;
    }
    
    var message = {
        eventName: name,
        param: params
    };
    
    callPlatformSpecificMethod('firebaseLogEvent', message);
}

function firebaseSetUserProperty(name, value) {
    if (!name || !value) {
        return;
    }
    
    var message = {
        name: name,
        value: value
    };
    
    callPlatformSpecificMethod('firebaseSetUserProperty', message);
}

// 페이지 로딩 시 또는 특정 동작을 할 때 권한 상태 확인
function checkCameraPermission(onPermissionChecked) {
    navigator.permissions.query({ name: 'camera' })
        .then((permissionStatus) => { // 여기서 화살표 함수 사용
            // 클로저를 통해 permissionStatus.state를 외부 함수에 전달
            onPermissionChecked(permissionStatus.state);
        })
        .catch(function(error) {
            alert('카메라 권한 상태 확인 오류: ' + error);
        });
}

function checkLocationPermission(callback) {
    if (navigator.permissions) {
        navigator.permissions.query({ name: 'geolocation' }).then((permissionStatus) => {
            if (permissionStatus.state === 'granted') {
                callback('granted');
            } else if (permissionStatus.state === 'prompt') {
                callback('prompt');
            } else if (permissionStatus.state === 'denied') {
                callback('denied');
            }
            permissionStatus.onchange = () => {
                callback(permissionStatus.state);
            };
        });
    } else {
        // 브라우저가 Permissions API를 지원하지 않는 경우
        alert('Permissions API is not supported by this browser.');
        callback('unsupported');
    }
}

// 위치
function cb_UpdatingLocation(response) {
    onAppResponse("App Response: " + JSON.stringify(response));
}

function getLocation() {
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(showPosition, showError);
    } else {
        document.getElementById("location").innerHTML = "Geolocation is not supported by this browser.";
    }
}

function showPosition(position) {
    var latitude = position.coords.latitude;
    var longitude = position.coords.longitude;
    alert("Latitude: " + latitude + "<br>Longitude: " + longitude);
    document.getElementById("location").innerHTML = "Latitude: " + latitude + "<br>Longitude: " + longitude;
}

function showError(error) {
    alert("error");
    switch(error.code) {
        case error.PERMISSION_DENIED:
            document.getElementById("location").innerHTML = "User denied the request for Geolocation.";
            break;
        case error.POSITION_UNAVAILABLE:
            document.getElementById("location").innerHTML = "Location information is unavailable.";
            break;
        case error.TIMEOUT:
            document.getElementById("location").innerHTML = "The request to get user location timed out.";
            break;
        case error.UNKNOWN_ERROR:
            document.getElementById("location").innerHTML = "An unknown error occurred.";
            break;
    }
}
