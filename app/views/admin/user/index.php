<div class="page-header row">
    <div class="col-sm-7">
        <h1>Admin Users</h1>
    </div>

    <div class="col-sm-5 pull-left">
        <span class="pull-right">
            <div class="btn-group">
                <a class="btn btn-info" href="/admin/users?format=csv"><?= HTML::icon('download-alt') ?> Download CSV</a>
                <a class="btn btn-success" href="/admin/users/create"><?= HTML::icon('plus-sign') ?> New Entry</a>
            </div>
        </span>
    </div>
</div>

<?= HTML::flash() ?>

<div class="table-responsive">
    <table class="table table-striped table-bordered table-hover table-valign-middle table-fixed" valign="middle">
        <tr>
            <th class="text-center" width=40>ID</th>
            <th width=66>Avatar</th>
            <th>Email</th>
            <th class="text-center text-muted" colspan=2 width=70>Actions</th>
        </tr>

        <?php foreach ($users as $user): ?>
            <tr>
                <td class="text-center"><?= $user->id ?></td>
                <td><img src="<?= $user->getAvatar(50) ?>" width=50 height=50 alt="<?= $user->name ?>" class="img-rounded"></td>
                <td><?= $user->email ?></td>
                <td width=10 class="row-action">
                    <a class="btn btn-link unstyled-link" href="<?= '/admin/users/'.$user->id .'/edit'?>" data-toggle="tooltip" data-trigger="hover" data-placement="auto" title="Edit User"><?= HTML::icon('pencil') ?></a>
                </td>
                <td width=10 class="row-action">
                    <?= Form::open(array('url' => '/admin/users/'.$user->id, 'method' => 'delete')) ?>
                        <button class="btn btn-link unstyled-link" type="submit"  data-toggle="tooltip" data-trigger="hover" data-placement="auto" title="Delete User"><?= HTML::icon('trash') ?></button>
                    <?= Form::close() ?>
                </td>
            </tr>
        <?php endforeach; ?>
    </table>
</div>

<?php echo $users->links(); ?>
