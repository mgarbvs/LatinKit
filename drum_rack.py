"""drum_rack.py -- write Ableton Drum Rack presets (.adg) of Max for Live devices; used by make_kit.py.

From DRM1's scripts/make_presets.py (same file format; templates/rack.xml and templates/pad.xml were written by Live).
In a Max device preset Live lists the parameters by name, alphabetically; that order is their Index.
"""
import gzip
import json
import os
import re
from xml.sax.saxutils import escape


def params_of(maxpat):
    """{varname: valueof dict} of a built device"""
    out = {}

    def walk(p):
        for b in p["boxes"]:
            b = b["box"]
            vo = b.get("saved_attribute_attributes", {}).get("valueof")
            if b.get("parameter_enable") and vo:
                out[b["varname"]] = vo
            if "patcher" in b:
                walk(b["patcher"])
    walk(json.load(open(maxpat))["patcher"])
    return out


def q(v):
    return escape(str(v), {'"': "&quot;"})


def num(v):
    return repr(float(v)).removesuffix(".0") if float(v) == int(float(v)) else repr(float(v))


def param_xml(i, vo, value):
    name, short, t = vo["parameter_longname"], vo["parameter_shortname"], vo.get("parameter_type", 0)
    head = f'<Index Value="{i}" /><Type Value="{t}" /><Name Value="{q(name)}" /><ShortName Value="{q(short)}" />'
    target = '<AutomationTarget Id="0"><LockEnvelope Value="0" /></AutomationTarget>'
    if t == 2:
        enum = vo["parameter_enum"]
        names = "".join(f'<Name Id="{k}"><Name Value="{q(n)}" /></Name>' for k, n in enumerate(enum))
        return (f'<MxDEnumParameter Id="{i}">{head}<MinValue Value="0" /><MaxValue Value="{len(enum) - 1}" />'
                f'<Default Value="{num(vo["parameter_initial"][0])}" /><ModType Value="0" /><MinMod Value="-1" />'
                f'<MaxMod Value="1" /><IsUndoable Value="true" /><IsStored Value="true" /><Timeable><LomId Value="0" />'
                f'<Manual Value="{num(value)}" />{target}</Timeable><Names>{names}</Names></MxDEnumParameter>')
    lo, hi = vo.get("parameter_mmin", 0.0), vo.get("parameter_mmax", 127.0)
    tag, mod = ("MxDIntParameter", 4) if t == 1 else ("MxDFloatParameter", 2)
    return (f'<{tag} Id="{i}">{head}<MinValue Value="{num(lo)}" /><MaxValue Value="{num(hi)}" />'
            f'<Default Value="{num(vo["parameter_initial"][0])}" /><ModType Value="{mod}" /><MinMod Value="-1" />'
            f'<MaxMod Value="1" /><IsUndoable Value="true" /><IsStored Value="true" /><Timeable><LomId Value="0" />'
            f'<Manual Value="{num(value)}" /><MidiControllerRange><Min Value="{num(lo)}" /><Max Value="{num(hi)}" />'
            f'</MidiControllerRange>{target}<ModulationTarget Id="0"><LockEnvelope Value="0" /></ModulationTarget>'
            f'</Timeable></{tag}>')


# every Max instrument Live writes has one (empty) audio in / out routable and a blob slot; without them loading the preset
# crashed Live (null pointer). Copied from Ableton's DS Kick as saved in a set (by ElektronBench/scripts/md_presets.py).
ROUTE_IN, ROUTE_OUT = (f'<MxD{k}Routable Id="0"><Routable><Target Value="Audio{io}/None" />'
                       '<UpperDisplayString Value="No Output" /><LowerDisplayString Value="" /><MpeSettings>'
                       '<ZoneType Value="0" /><FirstNoteChannel Value="1" /><LastNoteChannel Value="15" />'
                       '</MpeSettings><MpePitchBendUsesTuning Value="true" /></Routable><LomId Value="0" />'
                       f'</MxD{k}Routable>' for k, io in (("In", "In"), ("Out", "Out")))
HEAD = ('<?xml version="1.0" encoding="UTF-8"?>\n<Ableton MajorVersion="5" MinorVersion="12.0_12402" '
        'SchemaChangeCount="5" Creator="Ableton Live 12.4.5" Revision="">')


def device_xml(amxd, lib, defs, values, top=True):
    """<MxDeviceInstrument> for the device at `amxd` (its path relative to Live's User Library `lib`, which Live resolves first);
    top: a preset file's root device (no Id; inside a rack it has Id="0")"""
    plist = "".join(param_xml(i, defs[v], values[v]) for i, v in
                    enumerate(sorted(defs, key=lambda v: defs[v]["parameter_longname"].lower())))
    rel = os.path.relpath(amxd, lib)
    fileref = (f'<FileRef><RelativePathType Value="6" /><RelativePath Value="{q(rel)}" /><Path Value="{q(amxd)}" />'
               f'<Type Value="2" /><LivePackName Value="" /><LivePackId Value="" />'
               f'<OriginalFileSize Value="{os.path.getsize(amxd)}" /><OriginalCrc Value="0" /><SourceHint Value="" />'
               f'</FileRef>')
    ident = "" if top else ' Id="0"'
    return (f'<MxDeviceInstrument{ident}><LomId Value="0" /><LomIdView Value="0" /><IsExpanded Value="true" />'
            f'<BreakoutIsExpanded Value="false" /><On><LomId Value="0" /><Manual Value="true" /><AutomationTarget '
            f'Id="0"><LockEnvelope Value="0" /></AutomationTarget><MidiCCOnOffThresholds><Min Value="64" />'
            f'<Max Value="127" /></MidiCCOnOffThresholds></On><ModulationSourceCount Value="0" />'
            f'<ParametersListWrapper LomId="0" /><Pointee Id="0" /><LastSelectedTimeableIndex Value="0" />'
            f'<LastSelectedClipEnvelopeIndex Value="0" /><LastPresetRef><Value><AbletonDefaultPresetRef Id="1">'
            f'<FileRef><RelativePathType Value="0" /><RelativePath Value="" /><Path Value="" /><Type Value="2" />'
            f'<LivePackName Value="" /><LivePackId Value="" /><OriginalFileSize Value="0" /><OriginalCrc Value="0" />'
            f'<SourceHint Value="" /></FileRef><DeviceId Name="MxDeviceInstrument" /></AbletonDefaultPresetRef></Value>'
            f'</LastPresetRef>'
            f'<LockedScripts /><IsFolded Value="false" />'
            f'<ShouldShowPresetName Value="true" /><UserName Value="" /><Annotation Value="" /><SourceContext>'
            f'<Value /></SourceContext><MpePitchBendUsesTuning Value="true" /><ViewData Value="{{}}" />'
            f'<OverwriteProtectionNumber Value="3076" /><AudioOutputsListWrapper LomId="0" />'
            f'<AudioInputsListWrapper LomId="0" /><MidiOutputsListWrapper LomId="0" /><MidiInputsListWrapper '
            f'LomId="0" /><PatchSlot><Value><MxPatchRef Id="1">{fileref}<LastModDate '
            f'Value="{int(os.path.getmtime(amxd))}" /><SourceContext /><SampleUsageHint Value="0" /></MxPatchRef>'
            f'</Value></PatchSlot><ParameterList><ParameterList>{plist}</ParameterList></ParameterList>'
            f'<FileDropList><FileDropList /></FileDropList><IdRefList><IdRefList /></IdRefList><BlobSlot><Value>'
            f'<MxDBlob Id="2"><Blob /><HasData Value="true" /></MxDBlob></Value></BlobSlot>'
            f'<Routables><InRoutings>{ROUTE_IN}</InRoutings><OutRoutings>{ROUTE_OUT}</OutRoutings><MidiInRoutings />'
            f'<MidiOutRoutings /></Routables>'
            f'<MpeEnabled Value="false" /><MpeTuningEnabled Value="false" /></MxDeviceInstrument>')


def write_gz(path, xml):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with gzip.open(path, "wb") as f:
        f.write(xml.encode())


def safe(s):
    return re.sub(r'[/\\:*?"<>|\x00-\x1f\x7f]', "", s).strip() or "KIT"
