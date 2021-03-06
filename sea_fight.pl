use common::sense;
use DDP;
#$|=1;
my $A = fill_array();
my $B = fill_array();

my $show = SFDraw->new();
$show->main_window($A, $B);


say "q - quit, s - auto set ships";

my $user_input = 's';#<STDIN>;
#chomp($user_input);
exit if $user_input eq "q";

init_ships($A, $B) if $user_input eq "s";

$show->main_window($A, $B);

sub fill_array
{
  my @empty_space;

  for (my $i=0;$i<10;$i++)
  {
    for (my $j=0;$j<10;$j++)
    {
      $empty_space[$i][$j] = 0;
    }

  }

  return \@empty_space;
}

sub init_ships
{
  my ( $A, $B ) = @_;

  my @ships = (1,1,1,1,2,2,2,3,3,4);

  while (my $s = shift @ships)
  {
    my $res = check_position($s);
    # если не присвоили - ставим в конец очереди, чтобы потом снова попробовать присвоить
    unshift(@ships, $s) unless ($res);
  }
}

# определение позиции установки точки
sub check_position
{
  # палубность
  my $ship = shift;
  # если элемент присвоился - возвращаем 1, если нет - 0
  given ($ship){
    when(1) { return set_one(); }
    when(2) { return set_two(); }
    when(3) { return set_three(); }
    when(4) { return set_four(); }
  }

}

# проверяем свободен ли элемент, и если да - то проверяем всех соседей
# на свободность и возвращаем 1 если эл-т установился
sub set_one
{
  my $rand = int(rand(9));
  my $i = int(rand(9));
  # если точка свободна (т.е. == 0), то проверяем соседей
    unless (_is_busy($i,$rand))
    {
      # проверяем соседей
      if(check_neighbors($i,$rand))
      {
        $A->[$i][$rand] = 1;
        return 1;
      }
      else
      {
        return 0;
      }

      # если i нуль
      # if($i == 0 and $rand != 0)
      # {
      #   # если занят хотя бы один из соседей
      #   if($A->[$i][$rand-1] or $A->[$i][$rand+1] or $A->[$i][$rand]
      #     or $A->[$i+1][$rand-1] or $A->[$i+1][$rand] or $A->[$i+1][$rand+1])
      #   {
      #     return 0;
      #   }
      #   else
      #   {
      #     $A->[$i][$rand] = 1;
      #     return 1;
      #   }
      # }
      # # если rand 0 и i не 0
      # elsif($rand == 0 and $i != 0)
      # {
      #   if($A->[$i][$rand] or $A->[$i][$rand+1] or $A->[$i-1][$rand]
      #     or $A->[$i-1][$rand+1] or $A->[$i+1][$rand] or $A->[$i+1][$rand+1])
      #   {
      #     return 0;
      #   }
      #   else
      #   {
      #     $A->[$i][$rand] = 1;
      #     return 1;
      #   }
      # }
      # # если все нуль
      # elsif($rand == 0 and $i == 0)
      # {
      #   if($A->[$i][$rand] or $A->[$i][$rand+1] or $A->[$i+1][$rand] or $A->[$i+1][$rand] or $A->[$i+1][$rand+1])
      #   {
      #     return 0;
      #   }
      #   else
      #   {
      #     $A->[$i][$rand] = 1;
      #     return 1;
      #   }
      # }
      # else
      # {
      #    if($A->[$i][$rand-1] or $A->[$i][$rand+1] or $A->[$i-1][$rand-1] or $A->[$i-1][$rand]
      #     or $A->[$i-1][$rand+1] or $A->[$i+1][$rand-1] or $A->[$i+1][$rand] or $A->[$i+1][$rand+1])
      #   {
      #     return 0;
      #   }
      #   else
      #   {
      #     $A->[$i][$rand] = 1;
      #     return 1;
      #   }
      # }

    }
    # если занято, то return 0
    else
      {
        return 0;
      }

}

sub set_two
{
  my $rand = int(rand(9));
  my $i = int(rand(9));
}

sub set_three
{
  my $rand = int(rand(9));
  my $i = int(rand(9));
}

sub set_four
{
  my $rand = int(rand(9));
  my $i = int(rand(9));;
}

##### проверка ячеек
# проверяем всех соседей
sub check_neighbors
{
  my ( $x, $y ) = @_;
 # если заняты соседние то return 0
  if(_is_busy_top($x, $y) or _is_busy_left($x, $y) or _is_busy_right($x, $y) or _is_busy_bottom($x, $y) or _is_busy_cross_left_top($x, $y) or _is_busy_cross_right_top($x, $y) or _is_busy_cross_left_bottom($x, $y) or _is_busy_cross_right__bottom($x, $y))
  {
    return 0;
  }
  else
  {
    return 1;
  }
}
# текущая ячейка
sub _is_busy
{
  my ( $x, $y ) = @_;
  return 1 if $A->[$x][$y];
  return 0;
}
# проверка вершины
sub _is_busy_top
{
  my ( $x, $y ) =@_;
  # обрпаботка 0
  $y = $y ? $y-1 : $y;
  return 1 if $A->[$x][$y];
  return 0;
}
# проверка слева
sub _is_busy_left
{
  my ( $x, $y ) =@_;
  # обрпаботка 0
  $x = $x ? $x-1 : $x;
  return 1 if $A->[$x][$y];
  return 0;
}
# проверка справа
sub _is_busy_right
{
  my ( $x, $y ) =@_;
  return 1 if $A->[$x][$y+1];
  return 0;
}
# проверка низа
sub _is_busy_bottom
{
  my ( $x, $y ) =@_;
  return 1 if $A->[$x+1][$y];
  return 0;
}
# проверка диаг. слева вверху
sub _is_busy_cross_left_top
{
  my ( $x, $y ) =@_;
  # обрпаботка 0
  $x = $x ? $x-1 : $x;
  $y = $y ? $y-1 : $y;
  return 1 if $A->[$x][$y];
  return 0;
}
# проверка диаг. справа вверху
sub _is_busy_cross_right_top
{
  my ( $x, $y ) =@_;
  # обрпаботка 0
  $y = $y ? $y-1 : $y;
  return 1 if $A->[$x+1][$y-1];
  return 0;
}
# проверка диаг. слева внизу
sub _is_busy_cross_left_bottom
{
  my ( $x, $y ) =@_;
  # обрпаботка 0
  $x = $x ? $x-1 : $x;
  return 1 if $A->[$x-1][$y+1];
  return 0;
}
# проверка диаг. справа внизу
sub _is_busy_cross_right__bottom
{
  my ( $x, $y ) =@_;
  return 1 if $A->[$x+1][$y+1];
  return 0;
}

#####
package SFDraw;

sub new
{
  my $self = shift;
  bless( {}, $self );
}

sub main_window
{
  my ( $this, $A, $B ) = @_;

  if($^O eq 'MSWin32')
  {
    system("cls");
  }
  elsif($^O eq 'Linux')
  {
    system("clear");
  }

  draw_logo();

  draw_line();
  draw_tab(1);
  draw_line();
  say;
  draw_words();
  draw_tab(2);
  draw_words();
  say;
  draw_line();
  draw_tab(1);
  draw_line();
  say;
  show_fields($A, $B);
  say;
}

sub draw_logo
{
  draw_tab(2);
  say "="x22;
  draw_tab(2);
  say "===== SEA FIGHT! =====";
  draw_tab(2);
  say "="x22;

}

sub draw_tab
{
  my $t = shift;
  print "\t"x$t;
}

sub draw_line
{
  print "- "x12;
}

sub draw_words
{
  print uc("  | a b c d e f g h i j");
}

sub show_fields
{
  my $fieldA = shift;
  my $fieldB = shift;
  for (my $i=0;$i<10;$i++)
  {
    print $i . " | ";

    for (my $j=0;$j<10;$j++)
    {
      print $fieldA->[$i]->[$j] . " ";
    }

    draw_tab(1);

    print $i . " | ";
    for (my $j=0;$j<10;$j++)
    {
      print $fieldB->[$i]->[$j] . " ";
    }
    print "\n";
  }
}

1;
