/**
 * 角色管理的单例
 */
var Role = {
    id: "roleTable",	//表格id
    seItem: null,		//选中的条目
    table: null,
    layerIndex: -1
};
/**
 * 搜索角色
 */
Role.search = function () {
    var queryData = {};
    queryData['name'] = $("#name").val();
    queryData['tips'] = $("#tips").val();
    Role.table.refresh({query: queryData});
}

//高级重置
Role.reset = function () {
    $("form .form-group input").val("");
};

/**
 * 初始化表格的列
 */
Role.initColumn = function () {
    var columns = [
        {field: 'selectItem', radio: true},
        {title: 'id', field: 'id', visible: false, align: 'center', valign: 'middle'},
        {title: '角色', field: 'name', align: 'center', valign: 'middle', sortable: true},
        {title: '上级角色', field: 'pName', align: 'center', valign: 'middle', sortable: true},
        {title: '所属部门', field: 'deptName', align: 'center', valign: 'middle', sortable: true},
        {title: '英文别名', field: 'tips', align: 'center', valign: 'middle', sortable: true},
        {title: '排序', field: 'num', visible: false, align: 'center', valign: 'middle'}];
    return columns;
};

/**
 * 检查是否选中
 */
Role.check = function () {
    var selected = $('#' + this.id).bootstrapTable('getSelections');
    if (selected.length == 0) {
        Feng.info("请先选中表格中的某一记录！");
        return false;
    } else {
        Role.seItem = selected[0];
        return true;
    }
};

/**
 * 点击添加管理员
 */
Role.openAddPage = function () {
    var index = layer.open({
        type: 2,
        title: '添加角色',
        area: ['750px', '400px'], //宽高
        fix: false, //不固定
        maxmin: true,
        content: Feng.ctxPath + '/role/add'
    });
    this.layerIndex = index;
};

/**
 * 点击修改按钮时
 */
Role.openEditPage = function () {
    if (this.check()) {
        var index = layer.open({
            type: 2,
            title: '修改角色',
            area: ['750px', '400px'], //宽高
            fix: false, //不固定
            maxmin: true,
            content: Feng.ctxPath + '/role/edit/' + this.seItem.id
        });
        this.layerIndex = index;
    }
};

/**
 * 删除角色
 */
Role.delRole = function () {
    if (this.check()) {
        var operation = function () {
            var ajax = new $ax(Feng.ctxPath + "/role/delete", function () {
                Feng.success("删除成功!");
                Role.table.refresh();
            }, function (data) {
                Feng.error("删除失败!" + data.responseJSON.message + "!");
            });
            ajax.set("roleId", Role.seItem.id);
            ajax.start();
        };

        Feng.confirm("是否删除角色 " + Role.seItem.name + "?", operation);
    }
};

/**
 * 权限配置
 */
Role.assign = function () {
    if (this.check()) {
        var index = layer.open({
            type: 2,
            title: '权限配置',
            area: ['350px', '500px'], //宽高
            fix: false, //不固定
            maxmin: true,
            content: Feng.ctxPath + '/role/set_menu/' + this.seItem.id
        });
        this.layerIndex = index;
    }
};


$(function () {
    //激活菜单
    $("#power").attr("class", "active");
    $("#role").attr("class", "active");

    //加载表格数据
    var defaultColunms = Role.initColumn();
    var table = new BSTable(Role.id, "/role/list", defaultColunms);
    table.setPaginationType("client");
    table.init();
    Role.table = table;

});
