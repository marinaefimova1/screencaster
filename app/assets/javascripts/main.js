'use strict';

var mediaSource = new MediaSource();
mediaSource.addEventListener('sourceopen', handleSourceOpen, false);
var mediaRecorder;
var recordedBlobs;
var sourceBuffer;

var gumVideo = document.querySelector('video#gum');
var recordedVideo = document.querySelector('video#recorded');

var recordButton = document.querySelector('#record');
var downloadButton = document.querySelector('#download');
var fullScreen = document.querySelector('#fullscreen');

recordButton.onclick = toggleRecording;
fullScreen.onclick = toggleFullScreen;
downloadButton.onclick = download;

// window.isSecureContext could be used for Chrome
var isSecureOrigin = location.protocol === 'https:' ||
    location.host === 'localhost';
if (!isSecureOrigin) {
    alert('getUserMedia() must be run from a secure origin: HTTPS or localhost.' +
        '\n\nChanging protocol to HTTPS');
    location.protocol = 'HTTPS';
}

// Use old-style gUM to avoid requirement to enable the
// Enable experimental Web Platform features flag in Chrome 49

var constraints = {
    audio: true,
    video: true
};

function handleSuccess(stream) {
    console.log('getUserMedia() got stream: ', stream);
    window.stream = stream;
    if (window.URL) {
        gumVideo.src = window.URL.createObjectURL(stream);
    } else {
        gumVideo.src = stream;
    }
}

function handleError(error) {
    console.log('navigator.getUserMedia error: ', error);
}


var mediaDevices = (navigator.mediaDevices && navigator.mediaDevices.getUserMedia) ?
    navigator.mediaDevices : ((navigator.mozGetUserMedia || navigator.webkitGetUserMedia) ? {
    getUserMedia: function (c) {
        return new Promise(function (y, n) {
            (navigator.mozGetUserMedia ||
            navigator.webkitGetUserMedia).call(navigator, c, y, n);
        });
    }
} : null);

if (!mediaDevices) {
    alert('Ne poluchitsia !!! : )');
}

mediaDevices.getUserMedia(constraints).then(handleSuccess).catch(handleError);


function handleSourceOpen(event) {
    console.log('MediaSource opened');
    sourceBuffer = mediaSource.addSourceBuffer('video/webm; codecs="vp8"');
    console.log('Source buffer: ', sourceBuffer);
}

recordedVideo.addEventListener('error', function (ev) {
    console.error('MediaRecording.recordedMedia.error()');
    alert('Your browser can not play\n\n' + recordedVideo.src
        + '\n\n media clip. event: ' + JSON.stringify(ev));
}, true);

function handleDataAvailable(event) {
    if (event.data && event.data.size > 0) {
        recordedBlobs.push(event.data);
    }
}

function handleStop(event) {
    console.log('Recorder stopped: ', event);
}

function toggleRecording() {
    if (recordButton.textContent === 'Start Recording') {
        startRecording();
    } else {
        stopRecording();
        recordButton.textContent = 'Start Recording';
        downloadButton.disabled = false;
    }
}

// The nested try blocks will be simplified when Chrome 47 moves to Stable
function startRecording() {
    recordedBlobs = [];
    var options = {mimeType: 'video/webm;codecs=vp9'};
    if (!MediaRecorder.isTypeSupported(options.mimeType)) {
        console.log(options.mimeType + ' is not Supported');
        options = {mimeType: 'video/webm;codecs=vp8'};
        if (!MediaRecorder.isTypeSupported(options.mimeType)) {
            console.log(options.mimeType + ' is not Supported');
            options = {mimeType: 'video/webm'};
            if (!MediaRecorder.isTypeSupported(options.mimeType)) {
                console.log(options.mimeType + ' is not Supported');
                options = {mimeType: ''};
            }
        }
    }
    try {
        mediaRecorder = new MediaRecorder(window.stream, options);
    } catch (e) {
        console.error('Exception while creating MediaRecorder: ' + e);
        alert('Exception while creating MediaRecorder: '
            + e + '. mimeType: ' + options.mimeType);
        return;
    }
    console.log('Created MediaRecorder', mediaRecorder, 'with options', options);
    recordButton.textContent = 'Stop Recording';
    downloadButton.disabled = true;
    mediaRecorder.onstop = handleStop;
    mediaRecorder.ondataavailable = handleDataAvailable;
    mediaRecorder.start(10); // collect 10ms of data
    console.log('MediaRecorder started', mediaRecorder);
}

function stopRecording() {
    mediaRecorder.stop();
    console.log('Recorded Blobs: ', recordedBlobs);
    recordedVideo.controls = true;
}
// function download22() {
//
//     var blob = new Blob(recordedBlobs, {type: 'video/webm'});
//     var file_input = $('input[type=file]');
//     file_input.value = blob;
//
//     console.log(file_input);
//     // file = input.files[0];
//     // fr = new FileReader();
//     // fr.onload
//     // var fd = new FormData();
//     // fd.append('data', blob);
//     // NProgress.start();
//     // $.ajax({
//     //         url: 'welcome/upload',
//     //         method: 'POST',
//     //         data: fd,
//     //     })
//     //     .done(function (data) {
//     //         var container = document.getElementById('link');
//     //         container.innerHTML = '<div><b><a href="' + window.location.origin + '/' + data.hash_url + '">Get your video by link ' + window.location.origin + '/' + data.hash_url + '</a></b></div>';
//     //     });
//
// }
function download() {
    var blob = new Blob(recordedBlobs, {type: 'video/webm'});
    var fd = new FormData();
    fd.append('data', blob);

    $.ajax({
        url: 'welcome/upload',
        method: 'POST',
        data: fd,
        processData: false,
        contentType: false
    })
    .done(function (data) {
        var container = document.getElementById('link');
        container.innerHTML = '<div><b><a href="' + window.location.origin + '/' + data.hash_url + '">Get your video by link ' + window.location.origin + '/' + data.hash_url + '</a></b></div>';

    });

}

// $(function () {
//     $('#fileupload').fileupload({
//         dataType: 'json',
//         done: function (e, data) {
//             $.each(data.result.files, function (index, file) {
//                 $('<p/>').text(file.name).appendTo(document.body);
//             });
//         }
//     });
// });

function toggleFullScreen() {
    if (!document.fullscreenElement && !document.msFullscreenElement && !document.mozFullScreenElement && !document.webkitFullscreenElement) {
        if (document.body.requestFullscreen) {
            document.body.requestFullscreen();
        } else if (document.body.msRequestFullscreen) {
            document.body.msRequestFullscreen();
        } else if (document.body.mozRequestFullScreen) {
            document.body.mozRequestFullScreen();
        } else if (document.body.webkitRequestFullscreen) {
            document.body.webkitRequestFullscreen();
        }
        $('#fullscreen').addClass('on');
    } else {
        if (document.exitFullscreen) {
            document.exitFullscreen();
        } else if (document.msExitFullscreen) {
            document.msExitFullscreen();
        } else if (document.mozCancelFullScreen) {
            document.mozCancelFullScreen();
        } else if (document.webkitCancelFullScreen) {
            document.webkitCancelFullScreen();
        }
        $('#fullscreen').removeClass('on');
    }
}

var hideIconsAfterTimeout;
$(window).on('mousemove', function () {
    $('#icons').addClass('active');


    if (hideIconsAfterTimeout) {
        clearTimeout(hideIconsAfterTimeout);
    }

    hideIconsAfterTimeout = setTimeout(function () {
        $('#icons').removeClass('active');
    }, 2000);

});
