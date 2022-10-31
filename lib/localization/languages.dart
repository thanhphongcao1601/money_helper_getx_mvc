import 'package:get/get.dart';

class Languages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          //app
          'appName': 'Money Helper',
          'total': 'Total',
          'income': 'Income',
          'expense': 'Expense',
          //bottom nav bar
          'bottomNav.daily': 'Daily',
          'bottomNav.statistic': 'Statistic',
          'bottomNav.backup': 'Backup',
          'bottomNav.setting': 'Setting',
          //tab
          'tab.expense': 'Expense',
          'tab.income': 'Income',
          //form
          'form.dateAndTime': 'Date and Time',
          'form.dateAndTimeHint': 'Enter your date',
          'form.type': 'Type',
          'form.typeHint': 'Choose money type',
          //form-type-value
          'form.type.cash': 'Cash',
          'form.type.bank': 'Bank',
          'form.type.eWallet': 'E-wallet',
          'form.genre': 'Genre',
          'form.genreHint': 'Choose your genre',
          //form-genre-value
          'form.genre.mustHave': 'Must have',
          'form.genre.niceToHave': 'Nice to have',
          'form.genre.wasted': 'Wasted',

          'form.money': 'Money',
          'form.moneyHint': 'Enter your money',
          'form.money.validate': 'Money can not empty',
          'form.content': 'Content',
          'form.contentHint': 'Enter your content',
          'form.button.save': 'Save',
          'form.button.cancel': 'Cancel',
          'form.button.delete': 'Delete',
          'form.dialog.delete.title': 'Delete record?',
          'form.dialog.delete.content':
              'After delete record, you can not restore the record!',
          //setting
          'setting.darkMode': 'Dark mode',
          'setting.language': 'Language',
          'setting.updateProfile': 'Update profile',
          'setting.signOut': 'Sign out',
          //snackbar
          'snackbar.add.success.title': 'Success',
          'snackbar.add.success.message': 'You add a record completely',
          'snackbar.add.fail.title': 'Fail',
          'snackbar.add.fail.message': 'Fail to add a record',

          'snackbar.update.success.title': 'Success',
          'snackbar.update.success.message': 'You update record completely',
          'snackbar.update.fail.title': 'Fail',
          'snackbar.update.fail.message': 'Fail to update record',
          'snackbar.delete.success.title': 'Success',
          'snackbar.delete.success.message': 'You delete a record completely',
          'snackbar.delete.fail.title': 'Fail',
          'snackbar.delete.fail.message': 'Fail to delete record',
        },
        'vi_VN': {
          //app
          'appName': 'Quản lý chi tiêu',
          'total': 'Tổng',
          'income': 'Thu',
          'expense': 'Chi',
          //bottom nav bar
          'bottomNav.daily': 'Nhật ký',
          'bottomNav.statistic': 'Thống kê',
          'bottomNav.backup': 'Sao lưu',
          'bottomNav.setting': 'Cài dặt',
          //tab
          'tab.expense': 'Chi',
          'tab.income': 'Thu',
          //form
          'form.dateAndTime': 'Ngày và giờ',
          'form.dateAndTimeHint': 'Nhập ngày và giờ',
          'form.type': 'Loại tài khoản',
          //form-type-value
          'form.typeHint': 'Chọn loại tài khoản',
          'form.type.cash': 'Tiền mặt',
          'form.type.bank': 'Ngân hàng',
          'form.type.eWallet': 'Ví điện tử',
          'form.genre': 'Thể loại',
          'form.genreHint': 'Chọn thể loại',
          //form-genre-value
          'form.genre.mustHave': 'Cần thiết',
          'form.genre.niceToHave': 'Nên',
          'form.genre.wasted': 'Lãng phí',

          'form.money': 'Số tiền',
          'form.moneyHint': 'Nhập số tiền',
          'form.money.validate': 'Số tiền không được để trống',
          'form.content': 'Nội dung',
          'form.contentHint': 'Nhập nội dung',
          'form.button.save': 'Lưu',
          'form.button.cancel': 'Hủy',
          'form.button.delete': 'Xóa',
          'form.dialog.delete.title': 'Xóa bản ghi?',
          'form.dialog.delete.content':
              'Sau khi xóa, dữ liệu sẽ không thể khôi phục!',
          //setting
          'setting.darkMode': 'Chủ đề tối',
          'setting.language': 'Ngôn ngữ',
          'setting.updateProfile': 'Chỉnh sửa tài khoản',
          'setting.signOut': 'Đăng xuất',
          //snackbar
          'snackbar.add.success.title': 'Thành công',
          'snackbar.add.success.message': 'Bạn đã thêm thành công',
          'snackbar.add.fail.title': 'Thất bại',
          'snackbar.add.fail.message': 'Không thể thực hiện thêm bản ghi',

          'snackbar.update.success.title': 'Thành công',
          'snackbar.update.success.message': 'Cập nhật bản ghi thành công',
          'snackbar.update.fail.title': 'Thất bại',
          'snackbar.update.fail.message': 'Cập nhật bản ghi thất bại',

          'snackbar.delete.success.title': 'Thành công',
          'snackbar.delete.success.message': 'Xóa bản ghi thành công',
          'snackbar.delete.fail.title': 'Thất bại',
          'snackbar.delete.fail.message': 'Hello Xóa bản ghi thất bại',
        },
      };
}
