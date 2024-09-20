managed implementation in class ZBD_TB_MB_KUR unique;
strict ( 1 );

define behavior for ZDD_TB_MB_KUR alias A_KurBilgileri
persistent table zfi_tb_mb_kur
etag master LocalLastChangedAt
lock master
authorization master ( global )
{
  //  field ( mandatory : create )
  //   RateType,
  //   FromCurr,
  //   ToCurrncy,
  //   Mbkey;

  field ( readonly )
  CreatedAt,
  CreatedBy,
  LastChangedAt,
  LocalLastChangedAt,
  LocalLastChangedBy;

  //  field ( readonly : update )
  //   RateType,
  //   FromCurr,
  //   ToCurrncy,
  //   Mbkey;
  create;
  update;
  //  delete;

  mapping for zfi_tb_mb_kur
    {
      RateType           = rate_type;
      FromCurr           = from_curr;
      ToCurrncy          = to_currncy;
      Mbkey              = mbkey;
      FromFactor         = from_factor;
      ToFactor           = to_factor;
      Notactive          = notactive;
      CreatedBy          = created_by;
      CreatedAt          = created_at;
      LastChangedAt      = last_changed_at;
      LocalLastChangedBy = local_last_changed_by;
      LocalLastChangedAt = local_last_changed_at;
    }
}