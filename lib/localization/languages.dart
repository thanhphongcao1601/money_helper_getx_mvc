import 'package:get/get.dart';

class Languages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          //app
          'appName': 'Money Helper',
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
          'form.type.type1': 'cash',
          'form.type.type2': 'bank',
          'form.type.type3': 'e-wallet',
          'form.genre': 'Genre',
          'form.genreHint': 'Choose your genre',
          //form-genre-value
          'form.genre.genre1': 'Must have',
          'form.genre.genre2': 'Nice to have',
          'form.genre.genre3': 'Wasted',

          'form.money': 'Money',
          'form.moneyHint': 'Enter your money',
          'form.money.validate': 'Money can not empty',
          'form.content': 'Content',
          'form.contentHint': 'Enter your content',
          'form.button.save': 'Save',
          'form.button.delete': 'Delete',
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
        },
        'vi_VN': {
          //app
          'appName': 'Quản lý chi tiêu',
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
          'form.type.type1': 'Tiền mặt',
          'form.type.type2': 'Ngân hàng',
          'form.type.type3': 'Ví điện tử',
          'form.genre': 'Thể loại',
          'form.genreHint': 'Chọn thể loại',
          //form-genre-value
          'form.genre.genre1': 'Bắt buộc',
          'form.genre.genre2': 'Nên',
          'form.genre.genre3': 'Lãng phí',

          'form.money': 'Số tiền',
          'form.moneyHint': 'Nhập số tiền',
          'form.money.validate': 'Số tiền không được để trống',
          'form.content': 'Nội dung',
          'form.contentHint': 'Nhập nội dung',
          'form.button.save': 'Lưu',
          'form.button.delete': 'Xóa',
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
        },
      };
}
