import 'package:get/get.dart';

class Languages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          //app
          'appName': 'Money Helper',
          'welcomeBack': 'Welcome back',
          'total': 'Total',
          'income': 'Income',
          'expense': 'Expense',
          'noData': 'No data',
          //bottom nav bar
          'bottomNav.daily': 'Daily',
          'bottomNav.statistic': 'Statistic',
          'bottomNav.loan': 'Loan',
          'bottomNav.setting': 'Setting',
          //tab
          'tab.expense': 'Expense',
          'tab.income': 'Income',
          //form
          'form.dateAndTime': 'Date and Time',
          'form.dateAndTime.validate': 'Date and time can not be empty',
          'form.dateAndTimeHint': 'Enter your date',
          'form.type': 'Type',
          'form.typeHint': 'Choose money type',
          //form-type-value
          'form.type.cash': 'Cash',
          'form.type.bank': 'Bank',
          'form.type.eWallet': 'E-wallet',
          'form.genre': 'Genre',
          'form.genre.validate': 'Genre can not be empty',
          'form.genreHint': 'Choose your genre',
          //form-genre-value
          'form.genre.mustHave': 'Must have',
          'form.genre.niceToHave': 'Nice to have',
          'form.genre.wasted': 'Wasted',
          'form.genre.eating': 'Eating',
          'form.genre.entertainment': 'Entertainment',
          'form.genre.development': 'Development',
          'form.genre.transportation': 'Transportation',
          'form.genre.hobby': 'Hobby',
          'form.genre.living': 'Living',
          'form.genre.clothes': 'Clothes',
          'form.genre.beautify': 'Beautify',
          'form.genre.health': 'Health',
          'form.genre.education': 'Education',
          'form.genre.event': 'Event',
          'form.genre.other': 'Other',
          'form.money': 'Money',
          'form.moneyHint': 'Enter your money',
          'form.money.validate': 'Money can not be empty',
          'form.content': 'Content',
          'form.contentHint': 'Enter your content',
          'form.content.validate': 'Content can not be empty',
          'form.personName': 'Person name',
          'form.personNameHint': 'Enter person name',
          //
          'form.button.save': 'Save',
          'form.button.cancel': 'Cancel',
          'form.button.delete': 'Delete',
          //
          'form.dialog.delete.title': 'Delete record?',
          'form.dialog.delete.content': 'Do you want to delete record?',
          'form.dialog.addNewItemSelected.title': 'Add new item',
          'form.addNewItemSelectedHint': 'Enter new item',
          'form.dialog.deleteItemSelected.title': 'Delete item?',
          'form.dialog.deleteItemSelected.content': 'Delete selected item',
          //loan
          'lend': 'Lend',
          'borrow': 'Borrow',
          'loan.lend': 'Lend',
          'loan.borrow': 'Borrow',
          //setting
          'setting.lockAppBiometrics': 'Biometrics',
          'setting.darkMode': 'Dark mode',
          'setting.language': 'Language',
          'setting.updateProfile': 'Update profile',
          'setting.signOut': 'Sign out',
          'setting.signIn': 'Sign in',
          'setting.backUp': 'Back up',
          //
          'setting.backUp.bottomSheet.chooseBackUpTime': 'Google Drive Back up',
          'setting.backUp.bottomSheet.autoBackUp': 'Auto back up every day',
          'setting.backUp.bottomSheet.daily': 'Daily',
          'setting.backUp.bottomSheet.weekly': 'Weekly',
          'setting.backUp.bottomSheet.backUp': 'Back up',
          'setting.backUp.bottomSheet.restore': 'Restore',
          'setting.backUp.bottomSheet.time': 'Time',
          'setting.backUp.bottomSheet.url': 'URL',
          'setting.backUp.bottomSheet.email': 'Email',
          'setting.backUp.bottomSheet.dialog.chooseFile':
              'Choose file to restore',
          //
          'setting.signOut.dialog.title': 'Sign out',
          'setting.signOut.dialog.title.content': 'Back up and sign out',
          'setting.signOut.dialog.confirmText': 'Yes',
          'setting.signOut.dialog.cancelText': 'No',
          //snackbar
          'snackbar.add.success.title': 'Success',
          'snackbar.add.success.message': 'You add a record completely',
          'snackbar.add.fail.title': 'Fail',
          'snackbar.add.fail.message': 'Fail to add a record',
          //
          'snackbar.update.success.title': 'Success',
          'snackbar.update.success.message': 'You update record completely',
          'snackbar.update.fail.title': 'Fail',
          'snackbar.update.fail.message': 'Fail to update record',
          //
          'snackbar.delete.success.title': 'Success',
          'snackbar.delete.success.message': 'You delete a record completely',
          'snackbar.delete.fail.title': 'Fail',
          'snackbar.delete.fail.message': 'Fail to delete record',
          //
          'snackbar.backup.success.title': 'Success',
          'snackbar.backup.success.message': 'Back up completely',
          'snackbar.backup.fail.title': 'Fail',
          'snackbar.backup.fail.message': 'Back up fail',
          //
          'snackbar.restore.success.title': 'Success',
          'snackbar.restore.success.message': 'Restore completely',
          'snackbar.restore.fail.title': 'Fail',
          'snackbar.restore.fail.message':
              'Restore fail, please check and try again',
          //
          'snackbar.signIn.fail.title': 'Login fail',
          'snackbar.signIn.fail.message':
              'Sign in fail, please check and try again'
        },
        'vi_VN': {
          //app
          'appName': 'Quản lý chi tiêu',
          'welcomeBack': 'Mừng trở lại',
          'total': 'Tổng',
          'income': 'Thu',
          'expense': 'Chi',
          'noData': 'Không có dữ liệu',
          //bottom nav bar
          'bottomNav.daily': 'Nhật ký',
          'bottomNav.statistic': 'Thống kê',
          'bottomNav.loan': 'Khoản vay',
          'bottomNav.setting': 'Cài dặt',
          //tab
          'tab.expense': 'Chi',
          'tab.income': 'Thu',
          //form
          'form.dateAndTime': 'Ngày và giờ',
          'form.dateAndTime.validate': 'Phải chọn ngày và giờ',
          'form.dateAndTimeHint': 'Nhập ngày và giờ',
          'form.type': 'Thể loại',
          //form-type-value
          'form.typeHint': 'Chọn thể loại',
          'form.type.cash': 'Tiền mặt',
          'form.type.bank': 'Ngân hàng',
          'form.type.eWallet': 'Ví điện tử',
          'form.genre': 'Thể loại',
          'form.genre.validate': 'Phải chọn thể loại',
          'form.genreHint': 'Chọn thể loại',
          //form-genre-value
          'form.genre.mustHave': 'Cần thiết',
          'form.genre.niceToHave': 'Nên',
          'form.genre.wasted': 'Lãng phí',
          'form.genre.eating': 'Ăn uống',
          'form.genre.entertainment': 'Giải trí',
          'form.genre.development': 'Tự phát triển',
          'form.genre.transportation': 'Xăng xe',
          'form.genre.hobby': 'Sở thích',
          'form.genre.living': 'Sinh hoạt',
          'form.genre.clothes': 'Áo quần',
          'form.genre.beautify': 'Làm đẹp',
          'form.genre.health': 'Sức khỏe',
          'form.genre.education': 'Giáo dục',
          'form.genre.event': 'Sự kiện',
          'form.genre.other': 'Khác',
          'form.money': 'Số tiền',
          'form.moneyHint': 'Nhập số tiền',
          'form.money.validate': 'Số tiền không được để trống',
          'form.content': 'Nội dung',
          'form.contentHint': 'Nhập nội dung',
          'form.content.validate': 'Thiếu nội dung',
          'form.personName': 'Tên',
          'form.personNameHint': 'Nhập tên',
          'form.personName.validate': 'Phải nhập tên',
          //
          'form.button.save': 'Lưu',
          'form.button.cancel': 'Hủy',
          'form.button.delete': 'Xóa',
          'form.dialog.delete.title': 'Xóa bản ghi?',
          'form.dialog.addNewItemSelected.title': 'Thêm thể loại',
          'form.addNewItemSelectedHint': 'Nhập thể loại',
          'form.dialog.delete.content': 'Xác nhận xóa bản ghi!',
          'form.dialog.deleteItemSelected.title': 'Xác nhận xóa?',
          'form.dialog.deleteItemSelected.content': 'Xóa mục được chọn',
          //loan
          'lend': 'Cho vay',
          'borrow': 'Nợ',
          'loan.lend': 'Cho vay',
          'loan.borrow': 'Nợ',
          //setting
          'setting.lockAppBiometrics': 'Xác thực bằng vân tay',
          'setting.darkMode': 'Chủ đề tối',
          'setting.language': 'Ngôn ngữ',
          'setting.backUp': 'Sao lưu',
          'setting.updateProfile': 'Chỉnh sửa tài khoản',
          'setting.signOut': 'Đăng xuất',
          'setting.signIn': 'Đăng nhập',
          //
          'setting.backUp.bottomSheet.chooseBackUpTime': 'Google Drive Sao lưu',
          'setting.backUp.bottomSheet.autoBackUp': 'Sao lưu tự động mỗi ngày',
          'setting.backUp.bottomSheet.daily': 'Hằng ngày',
          'setting.backUp.bottomSheet.weekly': 'Hằng tuần',
          'setting.backUp.bottomSheet.backUp': 'Sao lưu',
          'setting.backUp.bottomSheet.restore': 'Khôi phục',
          'setting.backUp.bottomSheet.time': 'Thời gian',
          'setting.backUp.bottomSheet.url': 'URL',
          'setting.backUp.bottomSheet.email': 'Email',
          'setting.backUp.bottomSheet.dialog.chooseFile':
              'Chọn file muốn khôi phục',
          //
          'setting.signOut.dialog.title': 'Đăng xuất',
          'setting.signOut.dialog.title.content': 'Sao lưu và đăng xuất?',
          'setting.signOut.dialog.confirmText': 'Sao lưu',
          'setting.signOut.dialog.cancelText': 'Đăng xuất',
          //snackbar
          'snackbar.add.success.title': 'Thành công',
          'snackbar.add.success.message': 'Bạn đã thêm thành công',
          'snackbar.add.fail.title': 'Thất bại',
          'snackbar.add.fail.message': 'Không thể thực hiện thêm bản ghi',
          //
          'snackbar.update.success.title': 'Thành công',
          'snackbar.update.success.message': 'Cập nhật bản ghi thành công',
          'snackbar.update.fail.title': 'Thất bại',
          'snackbar.update.fail.message': 'Cập nhật bản ghi thất bại',
          //
          'snackbar.delete.success.title': 'Thành công',
          'snackbar.delete.success.message': 'Xóa bản ghi thành công',
          'snackbar.delete.fail.title': 'Thất bại',
          'snackbar.delete.fail.message': 'Hello Xóa bản ghi thất bại',
          //
          'snackbar.backup.success.title': 'Thành công',
          'snackbar.backup.success.message':
              'Dữ liệu đã được sao lưu thành công',
          'snackbar.backup.fail.title': 'Thất bại',
          'snackbar.backup.fail.message': 'Sao lưu thất bại',
          //
          'snackbar.restore.success.title': 'Thành công',
          'snackbar.restore.success.message': 'Khôi phục dữ liệu hoàn tất',
          'snackbar.restore.fail.title': 'Thất bại',
          'snackbar.restore.fail.message': 'Khôi phục dữ liệu thất bại',
          //
          'snackbar.signIn.fail.title': 'Thất bại',
          'snackbar.signIn.fail.message':
              'Đăng nhập thất bại, kiểm tra và hãy thử lại'
        },
      };
}
