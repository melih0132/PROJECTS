   M S B A M L   `   `   `  ����F  BWpfVirement, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null)clr-namespace:WpfVirementWpfVirement  5      #    WpfVirement.RechercheVirement   5      W SPresentationCore, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35\ XPresentationFramework, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35e aSystem.Windows.Controls.Ribbon, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089R NWindowsBase, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35F 9http://schemas.microsoft.com/winfx/2006/xaml/presentation     5      R NSystem.Xaml, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089:x,http://schemas.microsoft.com/winfx/2006/xaml     5      @d2http://schemas.microsoft.com/expression/blend/2008     5      +localclr-namespace:WpfVirement     5      Jmc;http://schemas.openxmlformats.org/markup-compatibility/2006     5        � Title$  RechercheVirement��5      $	��800��5	      $	��450��5
      
�������.��5      � $��20q�6    � RowDefinitions 5   
   �� 5      $
��Auto �6   �� 5      $
��Auto �6   �� 5      $��* �6   .+�5   
   �� $��0��6   $��0,10,0,0q�6"   .+�5      �� $��Compte��5      $��14(�5      $
��Bold"�5      �� 5      $	��300��5      $��Center=�5       �� DisplayMemberPath$ IdCompte��5      ��5      �� *	Comptes+ �� SelectedItem 5      �� *Compte+5      �� 5!   
   $��1��6   $��0,20,0,0q�6"   .+�5"      �� $��Date de l'opération��5#      $��14(�5$      $
��Bold"�5%      (  "System.Windows.Controls.DatePicker  5&      $	��300��5'      $��Center=�5(         SelectedDate 5)      �� *SelectedDate+5*      �� 5,   
   $��2��5-      $��	0,20,0,10q�5.      $��Center=�5/      .+�50      �� -   5         ��Name$ BtRechercher��51      $	��760��52      $��40��53      ���#6A1B9A$��
Rechercher��55      $��14(�56      $
��Bold"�57      
�������58   $   59      &   System.Windows.Controls.DataGrid  5:   
   -   5          Name$ DataGridOperations��5;      $��2��5<      $��0,70,0,0q�5=         AlternatingRowBackground
 ����� �� AlternationCount$ 2��5?      	   AutoGenerateColumns$	 False��5@      
   CanUserReorderColumns$

 True��5A         CanUserResizeColumns$
 True��5B         CanUserResizeRows$ False��5C         CanUserSortColumns$
 True��5D      ��5E      �� *	Virements+   Columns 5F      0  *System.Windows.Controls.DataGridTextColumn  5G      ,  &System.Windows.Controls.DataGridColumn   Header$ N° Transaction��5I         
IsReadOnly$
 True��5J      1  +System.Windows.Controls.DataGridBoundColumn   Binding 5H      �� *IdTransacation+5J        5K      $ Date transaction��5M      $
 True��5N       5L      �� *DateTransacation+ �� StringFormat$ {0:dd/MM/yyyy}��5N        5O      $ Compte Débit��5Q      $
 True��5R       5P      �� *IdCompteDebit+5R        5S      $ Compte Crédit��5U      $
 True��5V       5T      �� *IdCompteCredit+5V        5W      $ Montant��5Y      $
 True��5Z       5X      �� *	Montant+5Z      5\      5_      5`      