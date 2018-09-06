<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title>软件中心 - 微力同步 verysync.com</title>
<link rel="stylesheet" type="text/css" href="index_style.css"/>
<link rel="stylesheet" type="text/css" href="form_style.css"/>
<link rel="stylesheet" type="text/css" href="usp_style.css"/>
<link rel="stylesheet" type="text/css" href="ParentalControl.css">
<link rel="stylesheet" type="text/css" href="css/icon.css">
<link rel="stylesheet" type="text/css" href="css/element.css">
<link rel="stylesheet" type="text/css" href="res/shadowsocks.css">
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/help.js"></script>
<script type="text/javascript" src="/validator.js"></script>
<script type="text/javascript" src="/js/jquery.js"></script>
<script type="text/javascript" src="/general.js"></script>
<script type="text/javascript" src="/switcherplugin/jquery.iphone-switch.js"></script>
<script type="text/javascript">
function init() {
	show_menu();
	buildswitch();
	conf2obj();
}

function menu_hook() {
	tabtitle[tabtitle.length - 1] = new Array("", "微力同步");
	tablink[tablink.length - 1] = new Array("", "Module_verysync.asp");
}

function done_validating() {
	refreshpage(5);
}

function buildswitch() {
	$("#switch").click(function() {
		if (document.getElementById('switch').checked) {
			document.form.verysync_enable.value = 1;
		} else {
			document.form.verysync_enable.value = 0;
		}
	});

	$("#swap_enable").click(function() {
		if (document.getElementById('swap_enable').checked) {
			document.form.verysync_swap_enable.value = "1";
		} else {
			document.form.verysync_swap_enable.value = "0";
		}
	});
}

function onSubmitCtrl(o, s) {
	var port = $('#verysync_port').val() ;
    if (port < 1024 || port > 65535){
        alert("端口应设置为1024-65535之间");
		return false;
    }
	var home = $('#verysync_home').val()
	if (home == "") {
		alert("您必须设定一个应用数据目录路径用于存储索引信息，请将该目录设定为有较大存储空间的位置")
		return false;
	}

	document.form.action_mode.value = s;
	showLoading(5);
	document.form.submit();
}

function conf2obj() {
	$.ajax({
		type: "get",
		url: "dbconf?p=verysync",
		dataType: "script",
		success: function(xhr) {
			var p = "verysync";
			var params = ["enabled", "port", "wan_enable", "home", "swap_enable"];
			for (var i = 0; i < params.length; i++) {
				if (db_verysync[p + "_" + params[i]]) {
					$("#verysync_" + params[i]).val(db_verysync[p + "_" + params[i]]);
				}
			}
			var rrt = document.getElementById("switch");
			if (db_verysync["verysync_enable"] != "1") {
				rrt.checked = false;
			} else {
				rrt.checked = true;
			}

			$('#swap_enable').attr("checked", db_verysync["verysync_swap_enable"] == "1");

			var verysync_disklist = <% dbus_get_def("verysync_disklist", "[]"); %>
			$.each(verysync_disklist, function(key, item){
				var option = $("<option></option>")
								.attr("value", item.mount_point)
								.text(item.mount_point+" 大小:"+item.size + " 可用:"+item.free)
				$('#verysync_home').append(option);
			});

			$('#verysync_home').val(db_verysync["verysync_home"])
		}
	});
}

function reload_Soft_Center() {
	location.href = "/Main_Soft_center.asp";
}

function reload_Soft_Center() {
	location.href = "/Main_Soft_center.asp";
}

//console.log('Apps',Apps);
//数据 -  绘制界面用 - 直接 声明一个 Apps 然后 post 到 sh 然后 由 sh 执行 存到 dbus
function verifyFields(focused, quiet){
	var port =E('verysync_port').value ;
    if(port < 1024 || port > 65535){
        alert("端口应设置为1024-65535之间");
    }
	return 1;
}
</script>
</head>
<body onload="init();">
	<div id="TopBanner"></div>
	<div id="Loading" class="popup_bg"></div>
	<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
	<form method="POST" name="form" action="/applydb.cgi?p=verysync_" target="hidden_frame">
	<input type="hidden" name="current_page" value="Module_verysync.asp"/>
	<input type="hidden" name="next_page" value="Module_verysync.asp"/>
	<input type="hidden" name="group_id" value=""/>
	<input type="hidden" name="modified" value="0"/>
	<input type="hidden" name="action_mode" value=""/>
	<input type="hidden" name="action_script" value=""/>
	<input type="hidden" name="action_wait" value="5"/>
	<input type="hidden" name="first_time" value=""/>
	<input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get("preferred_lang"); %>"/>
	<input type="hidden" name="SystemCmd" onkeydown="onSubmitCtrl(this, ' Refresh ')" value="verysync_config.sh"/>
	<input type="hidden" name="firmver" value="<% nvram_get("firmver"); %>"/>
	<input type="hidden" id="verysync_enable" name="verysync_enable" value='<% dbus_get_def("verysync_enable", "0"); %>'/>
	<input type="hidden" id="verysync_swap_enable" name="verysync_swap_enable" value='<% dbus_get_def("verysync_swap_enable", "0"); %>'/>
	<table class="content" align="center" cellpadding="0" cellspacing="0">
		<tr>
			<td width="17">&nbsp;</td>
			<td valign="top" width="202">
				<div id="mainMenu"></div>
				<div id="subMenu"></div>
			</td>
			<td valign="top">
				<div id="tabMenu" class="submenuBlock"></div>
				<table width="98%" border="0" align="left" cellpadding="0" cellspacing="0">
					<tr>
						<td align="left" valign="top">
							<table width="760px" border="0" cellpadding="5" cellspacing="0" bordercolor="#6b8fa3" class="FormTitle" id="FormTitle">
								<tr>
									<td bgcolor="#4D595D" colspan="3" valign="top">
										<div>&nbsp;</div>
										<div style="float:left;" class="formfonttitle">微力同步</div>
										<div style="float:right; width:15px; height:25px;margin-top:10px"><img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></div>
										<div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"></div>
										<div class="formfontdesc" id="cmdDesc">开启微力同步后，你就拥有了私有的云盘，可以和您的任何设备进行高效的传输，目前支持所有主流的平台，下载其它客户端请到<a href="http://verysync.com/download?s=merlin" target="_blank">官网下载</a></div>
                                        <table style="margin:10px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" id="verysync_detail">
                                            <tr>
												<td>微力官网</td>
												<td><a href="http://verysync.com/?sid=merlin" target="_blank">http://verysync.com</a></td>
											</tr>
                                            <tr>
												<td>微力社区</td>
                                                <td><a href="http://forum.verysync.com/?sid=merlin" target="_blank">http://forum.verysync.com</a></td>
											</tr>
                                            <tr>
												<td>微信号</td>
                                                <td>verysync</td>
											</tr>
											<tr>
												<td>QQ群</td>
                                                <td>微力同步官方群: 851608182</td>
											</tr>
                                        </table>
                                        <table style="margin:10px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
											<thead>
											<tr>
												<td colspan="2">微力同步开关</td>
											</tr>
											</thead>
											<tr>
											<th>开启微力同步</th>
												<td colspan="2">
													<div class="switch_field" style="display:table-cell">
														<label for="switch">
															<input id="switch" class="switch" type="checkbox" style="display: none;">
															<div class="switch_container" >
																<div class="switch_bar"></div>
																<div class="switch_circle transition_style">
																<div></div>
																</div>
															</div>
														</label>
													</div>
													<span style="float: left;">安装包版本: <% dbus_get_def("softcenter_module_verysync_version", "-"); %></span>
													<br />
													<span style="float: left;">微力版本: <% dbus_get_def("verysync_version", "-"); %></span>
												</td>
											</tr>
											<tr>
												<th>微力管理界面</th>
												<td colspan="2">
													<a  href="http://<% nvram_get("lan_ipaddr_rt");%>:<% dbus_get_def("verysync_port", "8886");%>" target="_blank">http://<% nvram_get("lan_ipaddr_rt");%>:<% dbus_get_def("verysync_port", "8886");%></a>
												</td>
											</tr>
                                    	</table>
										<table style="margin:10px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" id="verysync_detail">
											<thead>
											<tr>
												<td colspan="2">微力同步 参数设置</td>
											</tr>
											</thead>
											<tr>
												<th>Web管理端口</th>
												<td>
													<div>
														<input type="txt" name="verysync_port" id="verysync_port" class="input_ss_table" maxlength="5" value="8886"/>
													</div>
												</td>
											</tr>
											<tr>
												<th>允许外网访问</th>
												<td>
													<select style="width:164px;margin-left: 2px;" class="input_option" id="verysync_wan_enable" name="verysync_wan_enable">
														<option value="0" selected>关闭</option>
														<option value="1">开启</option>
													</select>
												</td>
											</tr>
                                            <tr>
												<th>应用数据目录</th>
												<td>
													<!-- <input type="text" name="verysync_home" id="verysync_home" class="input_ss_table"  value="" /> -->
													<select name="verysync_home" id="verysync_home">
													<option>选择数据目录</option>
													</select>
													<br />
													<span>请指定硬盘路径，索引会占用较大的空间 建议设置为磁盘根目录,设定后如果修改该路径，同步的任务列表将重置</span>
												</td>
											</tr>
											<tr>
												<th>启用虚拟内存</th>
												<td>
													<input id="swap_enable" type="checkbox" />
													<br />
													<span style="float: left;">第一次启用初始化需要花费较多的时间，微力会自动创建512M的SWAP空间，第一次请多等待些许时间</span>
												</td>
											</tr>
										</table>
 										<div id="warn" style="display: none;margin-top: 20px;text-align: center;font-size: 20px;margin-bottom: 20px;" class="formfontdesc" id="cmdDesc"><i>开启双线路负载均衡模式才能进行本页面设置，建议负载均衡设置比例1：1</i></div>
										<div class="apply_gen">
											<button id="cmdBtn" class="button_gen" onclick="onSubmitCtrl(this, ' Refresh ')">提交</button>
										</div>
										<div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"></div>
									</td>
								</tr>
							</table>
						</td>
						<td width="10" align="center" valign="top"></td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	</form>
	<div id="footer"></div>
</body>
</html>
