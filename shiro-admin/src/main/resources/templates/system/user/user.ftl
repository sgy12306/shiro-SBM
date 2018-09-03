<!DOCTYPE HTML>
<html>
<head>
    <title>用户管理</title>
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <meta charset="UTF-8">
<#--bootstrap table-->
    <link rel="stylesheet" href="/static/plugins/bootstrap-table/bootstrap-table.min.css">
    <script src="/static/plugins/bootstrap-table/bootstrap-table.min.js"></script>
    <script src="/static/plugins/bootstrap-table/locale/bootstrap-table-zh-CN.js"></script>

    <!-- bootstrap datepicker -->
    <link rel="stylesheet" href="/static/bower_components/bootstrap-datepicker/dist/css/bootstrap-datepicker.min.css">
    <script src="/static/bower_components/bootstrap-datepicker/dist/js/bootstrap-datepicker.min.js"></script>
    <script src="/static/bower_components/bootstrap-datepicker/dist/locales/bootstrap-datepicker.zh-CN.min.js"></script>

    <link rel="stylesheet" href="/static/plugins/ztree/zTreeStyle.css">
    <script src="/static/plugins/ztree/jquery.ztree.all.min.js"></script>

    <script src="/static/plugins/common/ajax-object.js"></script>
<#--弹出层-->
    <script src="/static/plugins/layer/layer.js"></script>
<#--自定义封装-->
    <script src="/static/plugins/common/bootstrap-table-object.js"></script>
    <script src="/static/plugins/common/ztree-object.js"></script>
    <script src="/static/plugins/common/Feng.js"></script>
<#--本页JS-->
    <script src="/static/modular/system/user/user.js"></script>
</head>
<body>
<!-- Content Header (Page header) -->
<section class="content-header">
    <h1>用户管理
        <small></small>
    </h1>
    <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
        <li><a href="#">系统管理</a></li>
        <li class="active">用户管理</li>
    </ol>
</section>
<!-- Main content -->
<section class="content">
    <div class="row">
        <div class="col-lg-2">
            <div class="panel panel-default">
                <div class="panel-heading">组织机构</div>
                <div class="panel-body dept-tree">
                    <ul id="deptTree" class="ztree"></ul>
                </div>
            </div>
        </div>
        <div class="col-lg-10">
            <div class="row">
                <div class="col-md-12 col-lg-12">
                    <!-- Horizontal Form -->
                    <div class="box box-success">
                        <div class="box-header with-border">
                            <h3 class="box-title"><i class="fa fa-search"></i> 查询条件</h3>
                        </div>
                        <!-- /.box-header -->
                        <!-- form start -->
                        <form class="form-horizontal">
                            <div class="box-body">
                                <div class="form-group">
                                    <label for="name" class="col-lg-1 control-label"
                                           style="padding-right:0px;">名称</label>
                                    <div class="col-lg-5 ">
                                        <input class="form-control" type="text" id="name" name="name"
                                               placeholder="用户名称">
                                    </div>
                                    <label for="phone" class="col-lg-1 control-label"
                                           style="padding-right:0px;">电话</label>
                                    <div class="col-lg-5 ">
                                        <input class="form-control" type="text" id="phone" name="phone"
                                               placeholder="电话号码">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="beginTime" class="col-lg-1 control-label"
                                           style="padding-right:0px">日期</label>
                                    <div class="col-lg-5">
                                        <input class="form-control" type="text" id="beginTime"
                                               name="beginTime"
                                               placeholder="注册开始日期">
                                    </div>
                                    <label for="endTime" class="col-lg-1 control-label"
                                           style="padding-right:0px">日期</label>
                                    <div class="col-lg-5 ">
                                        <input class="form-control" type="text" id="endTime"
                                               name="endTime"
                                               placeholder="注册结束日期">
                                    </div>
                                </div>
                            </div>
                            <!-- /.box-body -->
                            <div class="box-footer text-center">
                                <button type="button" onclick="MgrUser.search();"
                                        class="btn btn-primary btn-sm no-margin-top">
                                    <i class="fa fa-check"></i> 查询
                                </button>
                                <button type="button" onclick="MgrUser.reset();"
                                        class="btn btn-default btn-sm no-margin-top">
                                    <i class="fa fa-refresh"></i>重置
                                </button>
                            </div>
                            <!-- /.box-footer -->
                        </form>
                    </div>
                    <!-- /.box -->
                </div>
            </div><!-- /.row -->
            <div class="row">
                <div class="col-xs-12">
                    <div class="box box-success">
                        <div class="box-body">
                            <div class="hidden-xs" id="managerTableToolbar" role="group">
                        <@shiro.hasPermission name="/mgr/add">
                            <button type="button" onclick="MgrUser.openAddPage();"
                                    class="btn btn-success btn-sm no-margin-top">
                                添加
                            </button>
                        </@shiro.hasPermission>
                        <@shiro.hasPermission name="/mgr/edit">
                            <button type="button" onclick="MgrUser.openEditPage();"
                                    class="btn btn-success btn-sm no-margin-top">
                                修改
                            </button>
                        </@shiro.hasPermission>
                        <@shiro.hasPermission name="/mgr/delete">
                            <button type="button" onclick="MgrUser.delUser();"
                                    class="btn btn-success btn-sm no-margin-top">
                                删除
                            </button>
                        </@shiro.hasPermission>
                        <@shiro.hasPermission name="/mgr/reset">
                            <button type="button" onclick="MgrUser.resetPwd();"
                                    class="btn btn-success btn-sm no-margin-top">
                                重置密码
                            </button>
                        </@shiro.hasPermission>
                        <@shiro.hasPermission name="/mgr/freeze">
                            <button type="button" onclick="MgrUser.freezeAccount();"
                                    class="btn btn-success btn-sm no-margin-top">
                                冻结用户
                            </button>
                        </@shiro.hasPermission>
                        <@shiro.hasPermission name="/mgr/unfreeze">
                            <button type="button" onclick="MgrUser.unfreeze();"
                                    class="btn btn-success btn-sm no-margin-top">
                                解除冻结
                            </button>
                        </@shiro.hasPermission>
                        <@shiro.hasPermission name="/mgr/setRole">
                            <button type="button" onclick="MgrUser.roleAssign();"
                                    class="btn btn-success btn-sm no-margin-top">
                                配置角色
                            </button>
                        </@shiro.hasPermission>
                            </div>
                            <table id="managerTable" data-mobile-responsive="true" data-click-to-select="true">
                            </table>
                        </div>
                        <!-- /.box-body -->
                    </div>
                    <!-- /.box -->
                </div>
                <!-- /.col -->
            </div>
        </div>
    </div>
    <!-- /.row -->
</section><!-- /.content -->
</body>
</html>