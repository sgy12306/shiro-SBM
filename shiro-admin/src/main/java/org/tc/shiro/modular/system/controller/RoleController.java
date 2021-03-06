package org.tc.shiro.modular.system.controller;

import com.stylefeng.guns.core.util.ToolUtil;
import com.stylefeng.guns.core.ztree.ZTreeNode;
import org.apache.shiro.authz.annotation.RequiresRoles;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.tc.mybatis.controller.BaseController;
import org.tc.mybatis.exception.GunsException;
import org.tc.mybatis.tips.Tip;
import org.tc.redis.cache.RedisCacheDao;
import org.tc.shiro.core.common.constant.AdminConst;
import org.tc.shiro.core.common.constant.cache.Cache;
import org.tc.shiro.core.common.constant.factory.ConstantFactory;
import org.tc.shiro.core.common.exception.BizExceptionEnum;
import org.tc.shiro.modular.system.service.IRoleService;
import org.tc.shiro.po.Role;
import org.tc.shiro.warpper.RoleWarpper;

import javax.validation.Valid;
import java.util.List;

/**
 * 角色控制器
 */
@Controller
@RequestMapping("/role")
public class RoleController extends BaseController {

    private static String PREFIX = "system/role";

    @Autowired
    private IRoleService roleService;
    @Autowired
    private RedisCacheDao redisCacheDao;

    /**
     * 角色列表页
     */
    @GetMapping("")
    public String index() {
        return PREFIX + "/role";
    }

    /**
     * 获取角色列表
     */
    @PostMapping("/list")
    @ResponseBody
    public Object list(@RequestParam(required = false) String name) {
        List<Role> list = roleService.list(name);
        return new RoleWarpper().warpList(list);
    }

    /**
     * 角色新增页面
     */
    @GetMapping("/add")
    public String roleAdd() {
        return PREFIX + "/add";
    }

    /**
     * 角色新增
     */
    @PostMapping("/add")
    @RequiresRoles(AdminConst.ADMIN_ROLE_NAME)
    @ResponseBody
    public Tip add(@Valid Role role, BindingResult result) {
        if (result.hasErrors()) {
            throw new GunsException(BizExceptionEnum.REQUEST_NULL);
        }
        this.roleService.insertAllCol(role);
        return SUCCESS_TIP;
    }

    /**
     * 角色修改页
     */
    @GetMapping("/edit/{roleId}")
    public String roleEdit(@PathVariable Integer roleId, Model model) {
        if (ToolUtil.isEmpty(roleId)) {
            throw new GunsException(BizExceptionEnum.REQUEST_NULL);
        }
        Role role = this.roleService.selectByPK(roleId);
        model.addAttribute("role", role);
        model.addAttribute("pName", ConstantFactory.me().getSingleRoleName(role.getPid()));
        model.addAttribute("deptName", ConstantFactory.me().getDeptName(role.getDeptid()));
        return PREFIX + "/edit";
    }

    /**
     * 角色修改
     */
    @PostMapping("/edit")
    @RequiresRoles(AdminConst.ADMIN_ROLE_NAME)
    @ResponseBody
    public Tip edit(@Valid Role role, BindingResult result) {
        Integer id = role.getId();
        if (result.hasErrors() || id == null) {
            throw new GunsException(BizExceptionEnum.REQUEST_NULL);
        }
        roleService.updateByPKSelective(role);
        //删除缓存
        redisCacheDao.removeAll(Cache.CONSTANT);
        return SUCCESS_TIP;
    }

    /**
     * 角色分配权限页
     */
    @RequestMapping("/set_menu/{roleId}")
    public String roleAssign(@PathVariable("roleId") Integer roleId, Model model) {
        if (ToolUtil.isEmpty(roleId)) {
            throw new GunsException(BizExceptionEnum.REQUEST_NULL);
        }
        model.addAttribute("roleId", roleId);
        model.addAttribute("roleName", ConstantFactory.me().getSingleRoleName(roleId));
        return PREFIX + "/menu_assign";
    }

    /**
     * 配置权限
     */
    @PostMapping("/set_menu")
    @RequiresRoles(AdminConst.ADMIN_ROLE_NAME)
    @ResponseBody
    public Tip setAuthority(@RequestParam("roleId") Integer roleId, @RequestParam("ids") String ids) {
        if (ToolUtil.isOneEmpty(roleId, ids)) {
            throw new GunsException(BizExceptionEnum.REQUEST_NULL);
        }
        this.roleService.setAuthority(roleId, ids);
        return SUCCESS_TIP;
    }

    /**
     * 删除角色
     */
    @PostMapping("/delete")
    @RequiresRoles(AdminConst.ADMIN_ROLE_NAME)
    @ResponseBody
    public Tip remove(@RequestParam Integer roleId) {
        if (ToolUtil.isEmpty(roleId)) {
            throw new GunsException(BizExceptionEnum.REQUEST_NULL);
        }
        //缓存被删除的角色名称
        this.roleService.delRoleById(roleId);
        //删除缓存
        redisCacheDao.removeAll(Cache.CONSTANT);
        return SUCCESS_TIP;
    }

//    /**
//     * 查看角色
//     */
//    @PostMapping("/view/{roleId}")
//    @ResponseBody
//    public Tip view(@PathVariable Integer roleId) {
//        if (ToolUtil.isEmpty(roleId)) {
//            throw new GunsException(BizExceptionEnum.REQUEST_NULL);
//        }
//        this.roleService.selectByPK(roleId);
//        return SUCCESS_TIP;
//    }

    /**
     * 角色node
     */
    @PostMapping("/tree")
    @ResponseBody
    public List<ZTreeNode> roleTreeList() {
        List<ZTreeNode> roleTreeList = this.roleService.getRoleTree();
        roleTreeList.add(ZTreeNode.createRoot());
        return roleTreeList;
    }

    /**
     * 角色树
     */
    @PostMapping("/treeByUserId/{userId}")
    @ResponseBody
    public List<ZTreeNode> roleTreeByUserId(@PathVariable Integer userId) {
        List<ZTreeNode> roleTreeList = roleService.getCheckedRoleTree(userId);
        return roleTreeList;
    }

}
