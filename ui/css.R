tags$meta(HTML("<meta charset='UTF-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1.0'>"))
tags$head(tags$style("h1{font-family:courier, courier new, serif;}
                         h2{font-family:courier, courier new, serif;}
                         h3{font-family:courier, courier new, serif;}
                         p{font-family:courier, courier new, serif;}
                         .bttn-bordered.bttn-success {
                           background: none;
                           border: 2px solid #333;
                           border-radius: 10px;
                           padding: 10px 15px;
                           cursor: pointer;
                           transition: all 0.3s ease;
                           font-size: 40px;
                           color: black;
                           
                         }
                         .bttn-bordered.bttn-success:focus, .bttn-bordered.bttn-success:hover {
    border-color: black;
                         }
.bttn-bordered.bttn-primary {
                           background: none;
                           border: none;
                           border-radius: 10px;
                           padding: 10px 15px;
                           cursor: pointer;
                           transition: all 0.3s ease;
                           font-size: 40px;
                           color: #197569;
                           
                         }
                         .bttn-bordered.bttn-primary:focus, .bttn-bordered.bttn-primary:hover {
    border-color: none;
                         }
.bttn-bordered.bttn-danger {
                           background: none;
                           border: none;
                           border-radius: 10px;
                           padding: 10px 15px;
                           cursor: pointer;
                           transition: all 0.3s ease;
                           font-size: 40px;
                           color: #9c3f28;
                           
                         }
                         .bttn-bordered.bttn-danger:focus, .bttn-bordered.bttn-danger:hover {
    border-color: none;
}
                         .container {
                           display:flex;
                            width:100%;
                           border: 2px solid #0a2d40;
                            animation: fadeIn 8s forwards;
                         }
                          
                        .cover-image-phone {
                            position: absolute;
                            bottom: 0;
                            left: 0;
                            width: 101%;
                            height: 160px;
                            object-fit: cover;
                            background-image: linear-gradient(#0a2d40, black);
                            text-align: center;
                            font-size: 70px;
                          }

                         .parent {
                         width: 100%;
                         display: flex;
                         }
                         .daughter {
                         display: flex;
                          width: 20%;
                          border: 2px solid white;
                         }
                         .middle {
                         display: flex;
                           width: 50%;
                           margin: 0% 5%;
                           
                         }
                   
                         .flip-horizontal {
                            transform: rotateY(180deg);
                         }
                          .startup-image {
                           display: flex;
                           width: 100%;
                           top: 0;
                           left: 0;
                           object-fit: cover;
                           display: block;
                          }
                          .login-screen-title {
    text-align: var(--f7-login-screen-title-text-align);
    font-size: var(--f7-login-screen-title-font-size);
    font-weight: var(--f7-login-screen-title-font-weight);
    color: var(--f7-login-screen-title-text-color);
    letter-spacing: var(--f7-login-screen-title-letter-spacing);
    height: 4%;
}
.list .item-input-wrap {
    width: 100%;
    display: flex;
}
.list .item-inner {
    width: 100%;
    min-width: 0;
    display: flex;
    justify-content: space-between;
    box-sizing: border-box;
    align-items: center;
    align-self: stretch;
    padding-top: var(--f7-list-item-padding-vertical);
    padding-bottom: var(--f7-list-item-padding-vertical);
    min-height: var(--f7-list-item-min-height);
    padding-right: calc(var(--f7-list-item-padding-horizontal) + var(--f7-safe-area-right));
}
.card-content-padding {
    position: relative;
    padding: 0;
}
.light .split-layout .page-content:not(.login-screen-content, .panel-content), .light .single-layout .page-content:not(.login-screen-content, .panel-content), .light .tab-layout .page-content:not(.login-screen-content, .panel-content), .light div.messages {
    background-color: white;
}
@keyframes fadeIn {
    from { opacity: 0; }
    to { opacity: 1; }
} 
html,body{overscroll-behavior-y: contain;}
"
),
tags$script("// Prevent variables from being global      
                          (function () {
                            
                            /*
                              1. Inject CSS which makes iframe invisible
                            */
                              
                              var div = document.createElement('div'),
                              ref = document.getElementsByTagName('base')[0] || 
                                document.getElementsByTagName('script')[0];
                              
                              div.innerHTML = '&shy;<style> iframe { visibility: hidden; } </style>';
                              
                              ref.parentNode.insertBefore(div, ref);
                              
                              
                              /*
                                2. When window loads, remove that CSS, 
                              making iframe visible again
                              */
                                
                                window.onload = function() {
                                  div.parentNode.removeChild(div);
                                }
                                
                          })();"),

tags$link(rel="icon", href = "favicon.ico"),
tags$link(href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css", rel="stylesheet"))